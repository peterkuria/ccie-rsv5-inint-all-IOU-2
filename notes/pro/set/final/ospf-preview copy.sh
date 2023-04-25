# Set interfaces for router-1
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.6/30

# Set interfaces for router-r2
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.5/30
set interfaces ge-0/0/0 unit 0 family inet address 192.168.1.254/24
set interfaces xe-0/0/0/35 unit 0 family inet address 172.16.0.1/30

# Set interfaces for router-r3
set interfaces xe-0/1/3 unit 0 family inet address 172.16.0.2/30

# Set OSPF for router-1
set protocols ospf area 0.0.0.0 interface ge-0/0/0.0
set protocols ospf area 0.0.0.0 interface lo0.0 passive

# Set OSPF for router-r2
set protocols ospf area 0.0.0.0 interface ge-0/0/0.0
set protocols ospf area 0.0.0.0 interface ge-0/0/0.1
set protocols ospf area 0.0.0.0 interface xe-0/0/0/35.

# Set OSPF for router-r3
set protocols ospf area 0.0.0.0 interface xe-0/1/3.0

# Set BGP for router-r2
set protocols bgp group EBGP type external
set protocols bgp group EBGP peer-as 65002
set protocols bgp group EBGP neighbor 172.16.0.6 multihop ttl 2
set protocols bgp group EBGP neighbor 172.16.0.6 export export-to-ospf
set protocols bgp group EBGP neighbor 172.16.0.6 import import-from-ospf
set protocols bgp group EBGP neighbor 172.16.0.6 description "peer to router-1"

# Set BGP for router-r2 as a route reflector
set protocols bgp group iBGP type internal
set protocols bgp group iBGP local-address 192.168.1.254
set protocols bgp group iBGP cluster 1
set protocols bgp group iBGP neighbor 172.16.0.2 peer-as 65003
set protocols bgp group iBGP neighbor 172.16.0.2 route-reflector-client
set protocols bgp group iBGP neighbor 172.16.0.6 peer-as 65001
set protocols bgp group iBGP neighbor 172.16.0.6 route-reflector-client

# Set policy options
set policy-options policy-statement export-to-ospf term term1 from protocol bgp
set policy-options policy-statement export-to-ospf term term1 then accept
set policy-options policy-statement import-from-ospf term term1 from protocol ospf
set policy-options policy-statement import-from-ospf term term1 then accept

# Set routing options
set routing-options static route 0.0.0.0/0 next-hop 192.168.1.1