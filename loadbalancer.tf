resource "volterra_healthcheck" "hc" {
  name      = format("%s-workload-hc", var.project_prefix)
  namespace = module.namespace.namespace["name"]

  http_health_check {
    use_origin_server_name = true
    path                   = "/"
  }
  healthy_threshold   = 1
  interval            = 15
  timeout             = 1
  unhealthy_threshold = 2
}

resource "volterra_origin_pool" "workload" {
  name                    = format("%s-workload", var.project_prefix)
  namespace               = module.namespace.namespace["name"]
  endpoint_selection      = "DISTRIBUTED"
  loadbalancer_algorithm  = "LB_OVERRIDE"
  port                    = 80
  no_tls                  = true

  origin_servers {
    private_ip {
      ip = vsphere_virtual_machine.ubuntu.default_ip_address
      outside_network = true
      site_locator {
        site {
          namespace = "system"
          name      = format("%s-vsphere1", var.project_prefix)
        }
      }
    }
  }

  advanced_options {
    disable_outlier_detection = false
    outlier_detection {
      base_ejection_time = 10000
      consecutive_5xx = 2
      consecutive_gateway_failure = 2
      interval = 5000
      max_ejection_percent = 100
    } 
  } 

  healthcheck {
    name = volterra_healthcheck.hc.name
  }
}


resource "volterra_http_loadbalancer" "site1" {
  name      = format("%s-site1", var.project_prefix)
  namespace = module.namespace.namespace["name"]
  no_challenge                    = true
  domains                         = [ "site1.local" ]

  disable_rate_limit              = true
  service_policies_from_namespace = true
  disable_waf                     = true
  source_ip_stickiness            = true

  advertise_custom {
    advertise_where {
      port = 80
      site {
        network = "SITE_NETWORK_OUTSIDE"
        ip      = "10.10.10.10"
        site {
          name      = format("%s-vsphere1", var.project_prefix)
          namespace = "system"
        }
      }
    }
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.workload.name
    }
    weight = 1
    priority = 1
  }

  http {
    dns_volterra_managed = false
    port = 80
  }

  depends_on = [ volterra_origin_pool.workload ]
}

resource "volterra_http_loadbalancer" "site2" {
  name      = format("%s-site2", var.project_prefix)
  namespace = module.namespace.namespace["name"]
  no_challenge                    = true
  domains                         = [ "site2.local" ]

  disable_rate_limit              = true
  service_policies_from_namespace = true
  disable_waf                     = true
  source_ip_stickiness            = true

  advertise_custom {
    advertise_where {
      port = 80
      site {
        network = "SITE_NETWORK_OUTSIDE"
        ip      = "10.10.11.10"
        site {
          name      = format("%s-vsphere2", var.project_prefix)
          namespace = "system"
        }
      }
    }
  }

  default_route_pools {
    pool {
      name = volterra_origin_pool.workload.name
    }
    weight = 1
    priority = 1
  }

  http {
    dns_volterra_managed = false
    port = 80
  }

  depends_on = [ volterra_origin_pool.workload ]
}

output "origin_pool" {
  value = resource.volterra_origin_pool.workload
}
output "http_loadbalancer1" {
  value = resource.volterra_http_loadbalancer.site1
}
output "http_loadbalancer2" {
  value = resource.volterra_http_loadbalancer.site2
}
output "health_check" {
  value = resource.volterra_healthcheck.hc
}

