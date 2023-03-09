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

## Testing

```
$ ./list_nodes.sh
[
  {
    "name": "marcel-ubuntu",
    "ip": "192.168.40.133"
  },
  {
    "name": "marcel-vsphere1-master-0",
    "ip": "192.168.40.171"
  },
  {
    "name": "marcel-vsphere2-master-0",
    "ip": "192.168.40.172"
  }
]
```

```
$ ssh ubuntu@192.168.40.133 
Welcome to Ubuntu 22.04.2 LTS (GNU/Linux 5.15.0-67-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

  System information as of Thu Mar  9 05:23:10 UTC 2023

  System load:  0.0               Processes:                139
  Usage of /:   24.5% of 9.51GB   Users logged in:          0
  Memory usage: 16%               IPv4 address for docker0: 172.17.0.1
  Swap usage:   0%                IPv4 address for ens192:  192.168.40.133

ubuntu@marcel-ubuntu:~$ curl -sH Host:site2.local -w 'Total: %{time_total}s\n' --output /dev/null http://10.10.11.10/1k
Total: 0.181146s
```
