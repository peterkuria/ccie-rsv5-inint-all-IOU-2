# IP ROUTING

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


## OSPF AND BGP 

router-r1
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.6/30
set interfaces ge-0/0/0 unit 0 family inet address 172.16.0.5/30
set interfaces xe-0/0/0/35 unit 0 family inet address 172.16.0.1/30
set interfaces xe-0/1/3 unit 0 family inet address 172.16.0.2/30
set interfaces ge-0/0/0 unit 0 family inet address 192.168.1.254/24

set routing-options router-id 1.1.1.1

set protocols bgp group ebgp type external
set protocols bgp group ebgp peer-as 2
set protocols bgp group ebgp neighbor 172.16.0.5
set protocols bgp group ebgp family inet unicast

set protocols bgp group ibgp type internal
set protocols bgp group ibgp local-address 192.168.1.254
set protocols bgp group ibgp family inet unicast
set protocols bgp group ibgp export ibgp-to-ospf
set protocols bgp group ibgp neighbor 172.16.0.6
set protocols bgp group ibgp neighbor 172.16.0.2

set protocols ospf area 0.0.0.0 interface ge-0/0/0.0 interface-type p2p
set protocols ospf area 0.0.0.0 interface xe-0/0/0/35.0 interface-type p2p
set protocols ospf area 0.0.0.0 interface xe-0/1/3.0 interface-type p2p

set policy-options policy-statement bgp-to-ospf term bgp-to-ospf from protocol bgp
set policy-options policy-statement bgp-to-ospf term bgp-to-ospf from community bgp-to-ospf
set policy-options policy-statement bgp-to-ospf term bgp-to-ospf then accept
set policy-options policy-statement bgp-to-ospf term default then reject

set policy-options policy-statement ospf-to-bgp term ospf-to-bgp from protocol ospf
set policy-options policy-statement ospf-to-bgp term ospf-to-bgp then community add ospf-to-bgp
set policy-options policy-statement ospf-to-bgp term ospf-to-bgp then accept

set policy-options policy-statement loop-filter term reject-from-bgp from protocol bgp
set policy-options policy-statement loop-filter term reject-from-bgp from community bgp-to-ospf
set policy-options policy-statement loop-filter term reject-from-bgp then reject

set policy-options policy-statement loop-filter term accept-all then accept

set protocols ospf export ospf-to-bgp
set protocols ospf import loop-filter
set protocols bgp group ibgp import bgp-to-ospf
set protocols bgp group ibgp export ospf-to-bgp


# optimise ospf
set protocols ospf interface ge-0/0/0 hello-interval 2
set protocols ospf interface ge-0/0/0 dead-interval 8


# router r2

