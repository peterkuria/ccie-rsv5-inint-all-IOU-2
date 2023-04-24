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

## Redistribution with policy
Assume we have the following network prefix(192.168.10.0/24) installed on our routing table: run show route: 
RA#
top edit policy-options policy-statement DIRECT-EXPORT
set term 1 from protocal direct
set term 1 from route-filter 192.168.10.0/24 exact
set term 1 then accept
// implicitely deny others
set term REJECT then reject 
show
top edit policy-options
top edit protocals bgp
edit group IBGP-SERVERS
set export DIRECT-EXPORT
top
commit

show | display set
// copy and edit config and load to Router RB for mutual prefix advertisement

##  On Route B we should now be able to view the new advertised route via bgp

RB#

set policy-options policy-statement DIRECT-EXPORT term 1 from protocal direct
set policy-options policy-statement DIRECT-EXPORT term 1 from route-filter 192.168.20.0/24 exact
set policy-options policy-statement DIRECT-EXPORT term then accept
set policy-options policy-statement DIRECT-EXPORT term  REJECT then reject





run show interfaces descriptions
run show route
top edit policy-options
top edit protocals bgp group IBGP-SERVERS  
set export DIRECT-EXPORT
  
commit
run show route

RA#
Test connectivity from site A
run ping 192.168.20.1 source 192.168.10.1


## Redistributing BGP into OSPF

If the BGP routes are already present in the routing-table of the SRX, you can use an Export-policy to distribute those routes via OSPF to other peers.

 

1. Create an Export-policy to match the BGP routes in the routing-table:

```
[edit policy-options]
user@srx# show
	policy-statement BGP-INTO-OSPF {
	    term BGP-ONLY {
	        from protocol bgp;
	        then {
	            accept;
	        }
```


2. Apply the Export-policy under OSPF:
```
[edit protocols]
user@srx# show
	ospf {
	    export BGP-INTO-OSPF;
	    area 0.0.0.0 {
	        interface ae0.0
	        interface ge-0/0/0.0

```

3. Confirm the routes advertisement (via LSAs) over OSFP:

	> run show ospf database advertising-router self

https://www.juniper.net/documentation/en_US/junos/topics/example/routing-policy-security-opspf-route-into-bpg-routing-table-injecting.html




## More examples
set policy-options prefix-list bgp-export 192.168.11.0/24
set policy-options prefix-list bgp-export 192.168.12.0/24
set policy-options policy-statement bgp-export term term-1 from prefix-list bgp-export
set policy-options policy-statement bgp export term term-1 then accept
set policy-options policy-statement bgp-export term reject-all then reject
set protocols bgp group bgp-group export bgp-export

Incase  OSPF is coming from my Cisco router was advertising a /32 network vs the /24. 
Since its in a lab environment, I was using loopback interfaces on the Cisco device to simulate networks on my backend. I had to go into the interface and tell the OSPF to be in point-to-point mode to advertise the full /24 network. Once that was done, the_packet_monkey's config was correct and advertised properly into BGP. 