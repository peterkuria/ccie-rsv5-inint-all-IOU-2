# Set hostname and enable SSH
set system host-name router-1
set system services ssh root-login allow
set system services ssh protocol-version v2

set system host-name router-2
set system services ssh root-login allow
set system services ssh protocol-version v2

set system host-name router-3
set system services ssh root-login allow
set system services ssh protocol-version v2

# Configure interfaces on Router-1
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.6/30

# Configure interfaces on Router-2
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.5/30
set interfaces ge-0/0/0 unit 0 family inet address 192.168.1.254/24
set interfaces xe-0/0/0 unit 0 family inet address 172.16.0.1/30

# Configure interfaces on Router-3
set interfaces xe-0/1/3 unit 0 family inet address 172.16.0.2/30

# Configure OSPF on Router-1
set protocols ospf area 0.0.0.0 interface ge-0/0/0.0
set protocols ospf area 0.0.0.0 interface lo0.0

# Configure OSPF on Router-2
set protocols ospf area 0.0.0.0 interface ge-0/0/0.0
set protocols ospf area 0.0.0.0 interface xe-0/0/0.0
set protocols ospf area 0.0.0.0 interface ge-0/0/0.1
set protocols ospf area 0.0.0.0 interface lo0.0

# Configure OSPF on Router-3
set protocols ospf area 0.0.0.0 interface xe-0/1/3.0
set protocols ospf area 0.0.0.0 interface lo0.0

# Configure BGP on Router-2
set protocols bgp group rr type internal
set protocols bgp group rr local-address 192.168.1.254
set protocols bgp group rr family inet unicast
set protocols bgp group rr cluster 1
set protocols bgp group rr neighbor 172.16.0.5
set protocols bgp group rr neighbor 172.16.0.2

# Configure BGP on Router-1 and Router-3
set protocols bgp group ext type external
set protocols bgp group ext family inet unicast
set protocols bgp group ext multihop
set protocols bgp group ext peer-as 65003
set protocols bgp group ext local-address 172.16.0.6
set protocols bgp group ext neighbor 172.16.0.5
set protocols bgp group ext neighbor 172.16.0.2

# Configure BGP on Route-2 (as a route reflector)
set protocols bgp group client type internal
set protocols bgp group client local-address 192.168.1.254
set protocols bgp group client family inet unicast
set protocols bgp group client cluster 1
set protocols bgp group client cluster-type internal
set protocols bgp group client cluster-id 1.1.1.1
set protocols bgp group client neighbor 172.16.0.6
set protocols bgp group client neighbor 172

###############
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.5/30
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.5/30
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.5/30
set interfaces xe-0/0/0 unit 0 family inet address 172.16.0.1/30
set interfaces xe-0/1/3 unit 0 family inet address 172.16.0.2/30

set protocols bgp group ebgp type external
set protocols bgp group ebgp export export-ebgp
set protocols bgp group ebgp peer-as 65001
set protocols bgp group ebgp neighbor 172.16.0.5 multihop ttl 255
set protocols bgp group ebgp neighbor 172.16.0.5 hold-time 30
set protocols bgp group ebgp neighbor 172.16.0.5 authentication md5 mypassword
set protocols bgp group ebgp neighbor 172.16.0.5 local-address 172.16.0.6

set protocols bgp group ibgp type internal
set protocols bgp group ibgp export export-ibgp
set protocols bgp group ibgp peer-as 65000
set protocols bgp group ibgp neighbor 192.168.0.1 peer-as 65001
set protocols bgp group ibgp neighbor 192.168.0.1 local-address 192.168.0.2
set protocols bgp group ibgp neighbor 192.168.0.1 import policy ibgp-in

set policy-options policy-statement export-ebgp term 1 from protocol direct
set policy-options policy-statement export-ebgp term 1 then accept

set policy-options policy-statement export-ibgp term 1 from protocol direct
set policy-options policy-statement export-ibgp term 1 then accept

set protocols ospf area 0.0.0.0 interface lo0.0
set protocols ospf area 0.0.0.0 interface ge-0/0/0
set protocols ospf area 0.0.0.0 interface xe-0/1/3

set routing-options static route 0.0.0.0/0 next-hop 192.168.1.1
