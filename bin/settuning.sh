#!/bin/bash

sysctl net.core.rmem_default=268435456
sysctl net.core.wmem_default=268435456
sysctl net.core.rmem_max=268435456
sysctl net.core.wmem_max=268435456
sysctl net.core.netdev_max_backlog=100000
sysctl "net.ipv4.tcp_rmem=4096 16384 134217728"
sysctl "net.ipv4.tcp_wmem=4096 16384 134217728"
sysctl "net.ipv4.tcp_mem=786432 1048576 268435456"
sysctl net.ipv4.tcp_max_tw_buckets=360000
sysctl net.ipv4.tcp_max_syn_backlog=10000
sysctl vm.min_free_kbytes=65536
sysctl vm.swappiness=0
sysctl net.core.somaxconn=10000
sysctl net.netfilter.nf_conntrack_max=1000000
sysctl fs.file-max=65536
