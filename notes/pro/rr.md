set groups EBGP neighbors 10.0.0.1 peer-as 1
set groups EBGP neighbors 10.0.0.1 multihop ttl 2
set groups EBGP neighbors 10.0.0.1 import-policy bgp-in
set groups EBGP neighbors 10.0.0.1 export bgp-out
set groups EBGP neighbors 10.0.0.2 peer-as 3
set groups EBGP neighbors 10.0.0.2 multihop ttl 2
set groups EBGP neighbors 10.0.0.2 import-policy bgp-in
set groups EBGP neighbors 10.0.0.2 export bgp-out

set protocols bgp group IBGP type internal
set protocols bgp group IBGP local-address 192.168.0.2
set protocols bgp group IBGP family inet unicast
set protocols bgp group IBGP neighbor 192.168.0.1 peer-as 2
set protocols bgp group IBGP neighbor 192.168.0.1 local-address 192.168.0.2
set protocols bgp group IBGP neighbor 192.168.0.1 update-source 172.16.0.5
set protocols bgp group IBGP neighbor 192.168.0.1 route-reflector-client
set protocols bgp group IBGP neighbor 192.168.0.3 peer-as 3
set protocols bgp group IBGP neighbor 192.168.0.3 local-address 192.168.0.2
set protocols bgp group IBGP neighbor 192.168.0.3 update-source 172.16.0.2
set protocols bgp group IBGP neighbor 192.168.0.3 route-reflector-client

set policy-options policy-statement ospf-in from protocol ospf
set policy-options policy-statement ospf-in then accept

set policy-options policy-statement bgp-out term 1 from protocol bgp
set policy-options policy-statement bgp-out term 1 from route-filter 0.0.0.0/0 exact
set policy-options policy-statement bgp-out term 1 then accept

set policy-options policy-statement bgp-in term 1 from protocol bgp
set policy-options policy-statement bgp-in term 1 then accept
set policy-options policy-statement bgp-in term 2 then reject

set protocols ospf area 0.0.0.0 interface ge-0/0/0.0 interface-type p2p
set protocols ospf area 0.0.0.0 interface xe-0/1/3.0 interface-type p2p
set protocols ospf export ospf-in
