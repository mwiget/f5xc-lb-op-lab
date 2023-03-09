# f5xc-lb-op-lab

- Deploy 2 CE's and one ubuntu based test server in vsphere with static IPs
- create lb and origin pool pointing to ubuntu server, exposed with different custom VIP per CE

## Diagram

```
        F5 Distributed Cloud
         /               \
        /                 \
       /                   \
+-------------+      +------------+
|  vsphere1   |      |  vsphere2  |
| origin_pool |      |  http lb   |
+-------------+      +------------+
      |                    |
 -----+----------+---------+-----
                 |
        +-----------------+
        |    ubuntu vm    |
        | client & server |
        +-----------------+
```

## Caveat

terraform needs to be applied twice, because the dynamic ip address of the ubuntu vm is used as input into
the loadbalancer manifest. 

