To test connectivity from Router-1 to Router-r3:

Router-1> 
ping routing-instance default 172.16.0.2 source 192.168.0.1
PING 172.16.0.2 (172.16.0.2): 56 data bytes
64 bytes from 172.16.0.2: icmp_seq=0 ttl=63 time=1.366 ms
64 bytes from 172.16.0.2: icmp_seq=1 ttl=63 time=1.298 ms
64 bytes from 172.16.0.2: icmp_seq=2 ttl=63 time=1.292 ms
64 bytes from 172.16.0.2: icmp_seq=3 ttl=63 time=1.299 ms
^C
--- 172.16.0.2 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max/stddev = 1.292/1.314/1.366/0.029 ms
To test connectivity from Router-r3 to Router-1:



Router-r3> ping routing-instance default 172.16.0.6 source 192.168.0.3
PING 172.16.0.6 (172.16.0.6): 56 data bytes
64 bytes from 172.16.0.6: icmp_seq=0 ttl=63 time=1.408 ms
64 bytes from 172.16.0.6: icmp_seq=1 ttl=63 time=1.269 ms
64 bytes from 172.16.0.6: icmp_seq=2 ttl=63 time=1.289 ms
64 bytes from 172.16.0.6: icmp_seq=3 ttl=63 time=1.283 ms
^C
--- 172.16.0.6 ping statistics ---
4 packets transmitted, 4 packets received, 0% packet loss
round-trip min/avg/max/stddev = 1.269/1.312/1.408/0.060 ms
To test connectivity from Router-1 to the default internet gateway (192.168.1.1):

python

Router-1> ping routing-instance default 192.168.1.1 source 192.168.0.1
PING 192.168.1.1 (192.168.1.1): 56 data bytes
64 bytes from 192.168.1.1: icmp_seq=0 ttl=64 time=3.337 ms
64 bytes from 192.168.1.1: icmp_seq=1 ttl=64 time=3.270 ms
64 bytes from 192.168.1.1: icmp_seq=2 ttl=64 time=3.182 ms
^C
--- 192.168.1.1 ping statistics ---
3 packets transmitted, 3 packets received, 0% packet loss
round-trip min/avg/max/stddev = 3.182/3.263/3.337/0.070 ms
To test connectivity from the default internet gateway (192.168.1.1) to Router-1:

arduino

Router-1> traceroute routing-instance default 192.168.0.1 source 192.207.172.51
traceroute to 192.168.0.1 (192.168.0.1), 30 hops max, 40 byte packets



### more loops test

Ping from router-1 to router-r3 using the local loopback as the source address:
shell

router-1> ping routing-instance R1-VR inet source 172.31.255.1 host 172.16.0.2
This should test the control plane communication via the route reflector.

Ping from router-1 to the device behind the default gateway (192.207.172.51) using the local loopback as the source address:
shell

router-1> ping routing-instance R1-VR inet source 172.31.255.1 host 192.207.172.51
This should test the data plane connectivity to the device behind the default gateway.

Ping from the device behind the default gateway to router-1 using the default gateway as the next-hop:
shell

Device_behind_default_gateway> ping 172.16.0.6
This should test the routing from the device behind the default gateway to router-1 via the default gateway.

Use traceroute from router-1 to router-r3 to ensure that the route reflector is being used:
shell

router-1> traceroute routing-instance R1-VR inet source 172.31.255.1 172.16.0.2
The output should show that the next hop is the IP address of router-2, the route reflector, rather than the direct link to router-r3.

To test for loops, we can use the "show route forwarding-table" command on each router to ensure that there are no loops in the forwarding table. We can also use the "show bgp summary" command on each router to verify that there are no routing loops in the BGP table.

show route forwarding-table


### OSPF 

Verify that the OSPF interface is up and that the OSPF neighbor is in the "Full" state:


show ospf neighbor
Verify that the router has received the expected LSAs from its OSPF neighbors:


show ospf database
Verify that the router has advertised its own LSAs to its OSPF neighbors:
php

show ospf database advertising-router <router-ID>
Verify that the router has installed the OSPF routes into its routing table:


show route protocol ospf
Verify that the router can ping the OSPF neighbors and other routers in the OSPF network:
css

ping <router-IP-address>
Verify the OSPF interface state and counters:
csharp

show ospf interface
If all of the above checks pass, it indicates that the OSPF LSA 1 is routable and the OSPF adjacency is full and not stuck.



To check the OSPF LSA 1 is routable:


show route table inet.0 192.168.1.0/24
This command will show the routing table entry for the network 192.168.1.0/24. If the route is present and the next-hop is a valid OSPF neighbor, then the LSA 1 is routable.

To check OSPF adjacency status:


show ospf neighbor
This command will display the OSPF neighbor information, including the state of the adjacency. If the adjacency is in a full state, then the OSPF neighbor is fully converged and the LSA 1 is routable.
