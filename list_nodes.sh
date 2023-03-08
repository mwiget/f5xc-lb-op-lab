#!/bin/bash
terraform output -json | jq -r '.vm.value, .vsphere1.value[][], .vsphere2.value[][] | { name:  .name, ip: .default_ip_address}'  | jq -n '. |= [inputs]'
