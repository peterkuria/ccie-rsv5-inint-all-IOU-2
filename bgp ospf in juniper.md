# BGP OSPF routing in Juniper

Logging to CLO


edit protocos ospf 
set area 0 interface xe-0/0/1.0  
show
commit

top 
run show ospf neighbor
run show route

To enable OSPF on all interfaces

set protocals ospf area 0 network 192.168.2.0/24
run show ip ospf nei


run ping xxx 

## BGP

set protocols bgp 1 neighnor 10.2.4.4 remote-as 2

// advertise loopback to ipv4 address family
set protocols bgp 1 address-family ipv4-unicast network 2.2.2.2/32
set redistribute ospf metric 1
commit

// enable ospf redistribution to bgp
set protocals ospf default-information originate always
commit

monitor traffic interface any filer icmp

show ip ro | match B
