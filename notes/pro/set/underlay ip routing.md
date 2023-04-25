A example script to configure the IP routing on the routers before OSPF and BGP are configured:

For Router-1:


set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.6/30
set routing-options static route 192.168.1.0/24 next-hop 172.16.0.5
set routing-options static route 192.207.172.51/32 next-hop 172.16.0.5


For Router-2:
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.5/30
set interfaces xe-0/0/0/35 unit 0 family inet address 172.16.0.1/30
set interfaces xe-0/1/3 unit 0 family inet address 172.16.0.2/30
set interfaces ge-0/0/1 unit 0 family inet address 192.168.1.254/24
set routing-options static route 0.0.0.0/0 next-hop 192.168.1.1


For Router-r3:

set interfaces xe-0/1/3 unit 0 family inet address 172.16.0.3/30
set routing-options static route 172.16.0.0/30 next-hop 172.16.0.2
set routing-options static route 192.207.172.51/32 next-hop 172.16.0.2