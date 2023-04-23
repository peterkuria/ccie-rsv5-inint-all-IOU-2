# Unique OSPF adjacency attributes

Task:

Deploy OSFP FRR with BGP on AWS with AWS CDK, or python, Pyjson or Terraform
BGP Aggregation - IP addressing. the base address is obtained by AND-ing all the addresses in a given range
MPLS Layer 3 VPN PE-CE Routing with OSPF - video 101
RFC 4577


015 - WAN circuits - HDLC, PPP
111 - IPv6 Routing

115 - OSPFv3 for IPv6

OSPFv3 can advertise both IPv4 and IPv6 NLRI - must: ipv6 enable
ensure we have 
ipv6 unicast-routing   

ospfv3 [process-id] [ipv4 | ipv6] area [area num]
ipv5 ospf1 area 0
router ospfv3 [process-id]

show ospfv3

108 - video  - GRE over IPSsec


## PPP

conf t
int s0/1
encapsulation ppp
end

debug ppp negotion


GRE crypto map

Add a tunnel to tun rouuting inside a GRE tunnel

You can enrypt the GRE tunnel inside of IPsec

1. First configure EIGRP as the underlay protocal or dynamic static route
advertising the loopbacks betwwen R7 and r8

2. configure GRE tunnel

GRE encapsulation  

[R9]==ospf on all interfa===[R7]====tunnel0=ospf=[R8]

R7#
int tunnel0
  tunnel source lo0
  tunnel destination 150.1.8.8
  ip address 78.0.0.7 255.255.255.0
! enable ospf on the tunnel
ip ospsf 1 area 0

int gig1.79
ip ospf 1 area 0


Enable OSPF only on the physical links (NOT on the loopback 150.1.8.8 though
OSPF AD is 110 while EIGRP 90, BGP 20)
R8#
int tunnel0
tunnel source loopback0
tunnel destination 150.1.7.7
ip address 78.0.0.8 255.255.255.0
ip ospsf 1 area 0

int gig1.108
ip ospf 1 area 0





Enable OSPF on all interface in R9 and R10(network 0.0.0.0 255.255.255.255 area 0)
You must set a unique router id or interface ip address.

GRE runs OSPF in P2P point to point(no DR election)

Ensure the tunnel source and destination ARE NOT  advertised on the overlay protocal(GRE. Routing must point to physical interface not tunnel. OSPF and EBGP would have routing Next Hope recursion issue since EBGP AD is lower(20) than OSPF and would be prefered for routing.

R7# show ip route ospf

show run int tunnel0

R9# ping 150.1.10.10 source 150.1.9.9

// you should see traffic routing thru the tunnel
R9#trace 150.1.10.10 source 150.1.9.9



## lab





The IP addresses must be unique for each router - should not be the same.(no duplicate address) 






Common OSPF adjaceny attributes

If we are on a different subnet or different areas, we cannot form adjacency

MTU must be match - not gige and serial link/100 Mge - 1500 bytes
 and network type must be compatible - check OSPF hello packets


EIGRP is distant factor routing based on destination prefixes while 

OSPF  linkstate is routing based on the nodes on the graph

router LSA that each router has is exchanged and on full adjacecncys nad db exchnages and traffic is now exchanged

show ip ospf neigbours

 

debug ip ospf adj
debug ip packet


OSPF route free alternate


/ if you issue /8 does not mean you are advertising /8 but the network interfaces OSPF is configured on   
  
## first checkou routing is enabled:

show ip int brief
//or to exclude unassigned addresses
show ip int brief | ex unassigned

The interfaces must be up up mode: and you must have layer 2 vlans connectivity

on router R8, r5, r4

[R8] == [R5]== [R4]




# enable on all device interfaces
conft t

router ospf ?
router ospf 1
router ospf 1 network 0.0.0.0 255.255.255.255 area 0
router ospf 1 network 0.0.0.0 255.255.255.255 area 0
router ospf 1 

auto-cost reference-bandwidth 100000 # 100 Gig
end
// auto-cost reference-bandwidth 100 # default is a 100 Meg







  network 0.0.0.0 255.255.255.255 area 0 # all interfaces

  network 1.2.0.0 0.255.255.255 area 1 # 
  network 155.1.0.0 0.0.255.255 area 0 # match first bits(155.1) assign to area 0 and ignore the last two(NOTE in OSPF and EIGRP I am NOT advertising the prefix 155.1.0.0/16 unlike in EGP which means originate)



Prefer to enable ospf on the link level- enables both
secondary and primar ip addresses

## OSPFT verification
show ip ospf

show ip ospf interface [brief]

# verify ospf adjacency
show ip ospf neighbor
debug ip ospf adj

# verify ospf database
show ip ospf database [router| network | summary | ... ]
show ip ospf database

Router Link State LSA is the most important - tells us how we route to the node


################ on supperputty send the command to all
conf t
router ospf 1
  network 155.1.0.0 0.0.255.255 area 0
  network 150.1.0.0 0.0.255.255 area 0
  fast-reroute per-prefix enable prefix-priority high
end
#################################


conf t
int gig1.100
ip ospf 1 area 0
ip ospf network point-to-point
ip ospf hello-interval 1
end

show run int gig1.45

#####################
# PACKET CAPTURE FOR OSPF using tftp
ip access-list ex OSPF
permit ospf any any
permit 89 any any
end

monitor capture 1 acc
monitor capture 1 access-list OSPF
monitor capture 1 int gig1.100 both
monitor capture 1 start
monitor capture 1 export tftp://10.0.0.100/R1.OSPF.pcap
 

########################
if you have only two routers connecte change connection type to P2P instead
of broadcast for fast convergence
network type point-to-point




#########################

R8#
show ip ospf nei
show ip ospf int brief


show ip ospf database router 150.1.8.8.

// view DR routes - LSA2 - net link states
show ip ospf database network 155.1.108.10

show ip ospf database router 150.1.10.10

show run | s ospf


Area 0 is the core 



show ip ospf neighbor = shows the node ID identifiers in the LSDB database(not shortest path to the node(not prefix since we may choose not to advertise it), which is done when we calculate SPF)


r5#sh ip route 150.1.8.8



(prefix may not be there althoug it is used as router id_

show route ospf



EBGP packets default to TTL 1
• Can be modified if neighbors are multiple hops away
• neighbor ebgp-multihop [ttl]
• neighbor ttl-security hops [ttl


R


##

```shell
!
version 15.2
!
enable
configure terminal
no service timestamps debug uptime
no service timestamps log uptime
!
hostname R8
!
no ip domain lookup
ip routing
ipv6 unicast-routing
!
cdp run
!
interface Loopback0
 ipv6 address 2001:150:8:8::8/128
 ip address 150.1.8.8 255.255.255.255
!
interface Ethernet0/1
 cdp enable
 no shutdown
!
interface Ethernet0/1.8
 encapsulation dot1q 8
 ip address 155.1.8.8 255.255.255.0
 ipv6 address 2001:155:1:8::8/64
!
interface Ethernet0/1.58
 encapsulation dot1q 58
 ip address 155.1.58.8 255.255.255.0
 ipv6 address 2001:155:1:58::8/64
!
interface Ethernet0/1.108
 encapsulation dot1q 108
 ip address 155.1.108.8 255.255.255.0
 ipv6 address 2001:155:1:108::8/64
!
router ospf 1
 network 155.1.0.0 0.0.255.255 area 0
 network 150.1.8.0 0.0.0.255 area 0
!
line con 0
 exec-timeout 0 0
 logging synchronous
 privilege level 15
 no login
!
line vty 0 4
 privilege level 15
 no login
!
end


!
end
```


## Router R5(RF)


```

!
version 15.2
!
enable
configure terminal
no service timestamps debug uptime
no service timestamps log uptime
!
hostname R5
!
no ip domain lookup
ip routing
ipv6 unicast-routing
!
cdp run
!
interface Loopback0
 ipv6 address 2001:150:5:5::5/128
 ip address 150.1.5.5 255.255.255.255
!
interface Ethernet0/1
 cdp enable
 no shutdown
!
interface Ethernet0/1.5
 encapsulation dot1q 5
 ip address 155.1.5.5 255.255.255.0
 ipv6 address 2001:155:1:5::5/64
!
interface Ethernet0/1.45
 encapsulation dot1q 45
 ip address 155.1.45.5 255.255.255.0
 ipv6 address 2001:155:1:45::5/64
!
interface Ethernet0/1.58
 encapsulation dot1q 58
 ip address 155.1.58.5 255.255.255.0
 ipv6 address 2001:155:1:58::5/64
!
interface Ethernet0/1.100
 encapsulation dot1q 100
 ip address 169.254.100.5 255.255.255.0
 ipv6 address 2001:169:254:100::5/64
!
crypto isakmp policy 10
 encr aes
 authentication pre-share
 group 5
 hash md5
! 
crypto isakmp key cisco address 0.0.0.0
!
crypto ipsec transform-set ESP_AES_SHA esp-aes esp-sha-hmac
!
crypto ipsec profile DMVPN_PROFILE
 set transform-set ESP_AES_SHA
!
interface Tunnel0
 ip address 155.1.0.5 255.255.255.0
 ip mtu 1400
 ip nhrp authentication NHRPPASS
 ip nhrp map multicast dynamic
 ip nhrp network-id 1
 ip tcp adjust-mss 1360
 delay 1000
 tunnel source Ethernet0/1.100
 tunnel mode gre multipoint
 tunnel key 150
 tunnel protection ipsec profile DMVPN_PROFILE
 ip ospf network point-to-multipoint non-broadcast
 no shutdown
! 
router ospf 1
 network 155.1.0.0 0.0.0.255 area 0
 network 155.1.45.0 0.0.0.255 area 0
 network 155.1.58.0 0.0.0.255 area 0
 network 155.1.5.0 0.0.0.255 area 0
 network 150.1.5.0 0.0.0.255 area 0
 neighbor 155.1.0.1
 neighbor 155.1.0.2
 neighbor 155.1.0.3
 neighbor 155.1.0.4
!
line con 0
 exec-timeout 0 0
 logging synchronous
 privilege level 15
 no login
!
line vty 0 4
 privilege level 15
 no login
!
end


!
end



```


E:\downloads\ccie-ine\CCIE Labs\ine rsv5-inint all-IOU copy\mpls.pe.ce.routing.with.ospf\R4.txt


## EBG MUltihop

R5
```
!
version 15.2
!

enable
conf t
version 15.4
no service timestamps debug uptime
no service timestamps log uptime
no platform punt-keepalive disable-kernel-core
interface Ethernet0/1
 no shut
exit
!
hostname R5
!
boot-start-marker
boot-end-marker
!
!
!
no aaa new-model
!
!
!
!
!
!
!


no ip domain lookup
!
!
!
ipv6 unicast-routing
!
!
!
!
!
!
!
subscriber templating
!
multilink bundle-name authenticated
!
!
license udi pid CSR1000V sn 9Y9VCZ8B841
license boot level premium
spanning-tree extend system-id
!
!
redundancy
 mode none
!
!
!
!
!
cdp run
!
! 
!
!
!
!
!
crypto isakmp policy 10
 encr aes
 hash md5
 authentication pre-share
 group 5
crypto isakmp key cisco address 0.0.0.0        
!
!
crypto ipsec transform-set ESP_AES_SHA esp-aes esp-sha-hmac 
 mode tunnel
!
crypto ipsec profile DMVPN_PROFILE
 set transform-set ESP_AES_SHA 
!
!
!
!
!
!
! 
! 
!
interface Loopback0
 ip address 150.1.5.5 255.255.255.255
 ipv6 address 2001:150:5:5::5/128
!
interface Tunnel0
 ip address 155.1.0.5 255.255.255.0
 no ip redirects
 ip mtu 1400
 ip nhrp authentication NHRPPASS
 ip nhrp map multicast dynamic
 ip nhrp network-id 1
 ip tcp adjust-mss 1360
 delay 1000
 tunnel source Ethernet0/1.100
 tunnel mode gre multipoint
 tunnel key 150
 tunnel protection ipsec profile DMVPN_PROFILE
!
interface Ethernet0/1
 no ip address
 negotiation auto
 cdp enable
!
interface Ethernet0/1.5
 encapsulation dot1Q 5
 ip address 155.1.5.5 255.255.255.0
 ipv6 address 2001:155:1:5::5/64
!
interface Ethernet0/1.45
 encapsulation dot1Q 45
 ip address 155.1.45.5 255.255.255.0
 shutdown
 ipv6 address 2001:155:1:45::5/64
!
interface Ethernet0/1.58
 encapsulation dot1Q 58
 ip address 155.1.58.5 255.255.255.0
 ipv6 address 2001:155:1:58::5/64
!
interface Ethernet0/1.100
 encapsulation dot1Q 100
 ip address 169.254.100.5 255.255.255.0
 ipv6 address 2001:169:254:100::5/64
!
interface GigabitEthernet2
 no ip address
 shutdown
 negotiation auto
!
interface GigabitEthernet3
 no ip address
 shutdown
 negotiation auto
!
!
router eigrp 100
 network 150.1.5.5 0.0.0.0
 network 155.1.0.0
!
router ospf 1
 router-id 150.1.5.5
 network 150.1.0.0 0.0.255.255 area 0
 network 155.1.0.0 0.0.255.255 area 0
!
router bgp 100
 bgp log-neighbor-changes
 network 150.1.5.5 mask 255.255.255.255
 neighbor 150.1.4.4 remote-as 100
 neighbor 150.1.4.4 update-source Loopback0
 neighbor 155.1.0.1 remote-as 100
 neighbor 155.1.0.2 remote-as 100
 neighbor 155.1.0.3 remote-as 100
 neighbor 155.1.37.7 remote-as 100
 neighbor 155.1.58.8 remote-as 100
 neighbor 155.1.146.6 remote-as 100
!
!
!
ip forward-protocol nd
!
no ip http server
no ip http secure-server
!
!
!
!
control-plane
!
!
line con 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line aux 0
 stopbits 1
line vty 0 4
 privilege level 15
 no login
!
!
end

R5#
!
end



```


## R4 EBGP multihop


```
!
version 15.2
!

enable
conf t
version 15.4
no service timestamps debug uptime
no service timestamps log uptime
no platform punt-keepalive disable-kernel-core
interface Ethernet0/1
 no shut
exit
!
hostname R4
!
boot-start-marker
boot-end-marker
!
!
!
no aaa new-model
!
!
!
!
!
!
!


no ip domain lookup
!
!
!
ipv6 unicast-routing
!
!
!
!
!
!
!
subscriber templating
!
multilink bundle-name authenticated
!
!
license udi pid CSR1000V sn 9Y9VCZ8B841
license boot level premium
spanning-tree extend system-id
!
!
redundancy
 mode none
!
!
!
!
!
cdp run
!
! 
!
!
!
!
!
crypto isakmp policy 10
 encr aes
 hash md5
 authentication pre-share
 group 5
crypto isakmp key cisco address 0.0.0.0        
!
!
crypto ipsec transform-set ESP_AES_SHA esp-aes esp-sha-hmac 
 mode tunnel
!
crypto ipsec profile DMVPN_PROFILE
 set transform-set ESP_AES_SHA 
!
!
!
!
!
!
! 
! 
!
interface Loopback0
 ip address 150.1.4.4 255.255.255.255
 ipv6 address 2001:150:4:4::4/128
!
interface Tunnel0
 ip address 155.1.0.4 255.255.255.0
 no ip redirects
 ip mtu 1400
 ip nhrp authentication NHRPPASS
 ip nhrp map 155.1.0.5 169.254.100.5
 ip nhrp map multicast 169.254.100.5
 ip nhrp network-id 1
 ip nhrp holdtime 300
 ip nhrp nhs 155.1.0.5
 ip tcp adjust-mss 1360
 tunnel source Ethernet0/1.100
 tunnel mode gre multipoint
 tunnel key 150
 tunnel protection ipsec profile DMVPN_PROFILE
!
interface Ethernet0/1
 no ip address
 negotiation auto
 cdp enable
!
interface Ethernet0/1.45
 encapsulation dot1Q 45
 ip address 155.1.45.4 255.255.255.0
 ipv6 address 2001:155:1:45::4/64
!
interface Ethernet0/1.100
 encapsulation dot1Q 100
 ip address 169.254.100.4 255.255.255.0
 ipv6 address 2001:169:254:100::4/64
!
interface Ethernet0/1.146
 encapsulation dot1Q 146
 ip address 155.1.146.4 255.255.255.0
 ipv6 address 2001:155:1:146::4/64
!
interface GigabitEthernet2
 no ip address
 shutdown
 negotiation auto
!
interface GigabitEthernet3
 no ip address
 shutdown
 negotiation auto
!
!
router eigrp 100
 network 150.1.4.4 0.0.0.0
 network 155.1.0.0
!
router ospf 1
 router-id 150.1.4.4
 network 150.1.0.0 0.0.255.255 area 0
 network 155.1.0.0 0.0.255.255 area 0
!
router bgp 100
 bgp log-neighbor-changes
 network 150.1.4.4 mask 255.255.255.255
 neighbor 150.1.5.5 remote-as 100
 neighbor 150.1.5.5 update-source Loopback0
 neighbor 155.1.0.1 remote-as 100
 neighbor 155.1.0.2 remote-as 100
 neighbor 155.1.0.3 remote-as 100
 neighbor 155.1.58.8 remote-as 100
 neighbor 155.1.67.7 remote-as 100
 neighbor 155.1.146.6 remote-as 100
!
!
virtual-service csr_mgmt
!
ip forward-protocol nd
!
no ip http server
no ip http secure-server
!
!
!
!
control-plane
!
!
line con 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line aux 0
 stopbits 1
line vty 0 4
 privilege level 15
 no login
!
!
end

R4#
!
end



```

## R8 EBGP multihop

```
!
version 15.2
!

enable
conf t
version 15.4
no service timestamps debug uptime
no service timestamps log uptime
no platform punt-keepalive disable-kernel-core
interface Ethernet0/1
 no shut
exit
!
hostname R8
!
boot-start-marker
boot-end-marker
!
!
!
no aaa new-model
!
!
!
!
!
!
!


no ip domain lookup
!
!
!
ipv6 unicast-routing
!
!
!
!
!
!
!
subscriber templating
!
multilink bundle-name authenticated
!
!
license udi pid CSR1000V sn 9Y9VCZ8B841
license boot level premium
spanning-tree extend system-id
!
!
redundancy
 mode none
!
!
!
!
!
cdp run
!
! 
!
!
!
!
!
!
!
!
!
!
!
!
! 
! 
!
interface Loopback0
 ip address 150.1.8.8 255.255.255.255
 ipv6 address 2001:150:8:8::8/128
!
interface Ethernet0/1
 no ip address
 negotiation auto
 cdp enable
!
interface Ethernet0/1.8
 encapsulation dot1Q 8
 ip address 155.1.8.8 255.255.255.0
 ipv6 address 2001:155:1:8::8/64
!
interface Ethernet0/1.58
 encapsulation dot1Q 58
 ip address 155.1.58.8 255.255.255.0
 ipv6 address 2001:155:1:58::8/64
!
interface Ethernet0/1.108
 encapsulation dot1Q 108
 ip address 155.1.108.8 255.255.255.0
 ipv6 address 2001:155:1:108::8/64
!
interface GigabitEthernet2
 no ip address
 shutdown
 negotiation auto
!
interface GigabitEthernet3
 no ip address
 shutdown
 negotiation auto
!
!
router eigrp 100
 network 155.1.8.8 0.0.0.0
 network 155.1.58.8 0.0.0.0
 network 155.1.108.0 0.0.0.255
 passive-interface Ethernet0/1.108
!
router bgp 100
 bgp log-neighbor-changes
 network 150.1.8.8 mask 255.255.255.255
 neighbor 155.1.0.1 remote-as 100
 neighbor 155.1.0.2 remote-as 100
 neighbor 155.1.0.3 remote-as 100
 neighbor 155.1.0.4 remote-as 100
 neighbor 155.1.37.7 remote-as 100
 neighbor 155.1.58.5 remote-as 100
 neighbor 155.1.108.10 remote-as 54
 neighbor 155.1.146.6 remote-as 100
!
!
!
ip forward-protocol nd
!
no ip http server
no ip http secure-server
!
!
!
!
control-plane
!
!
line con 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line aux 0
 stopbits 1
line vty 0 4
 privilege level 15
 no login
!
!
end

R8#
!
end



```


# R5 mpls pe.ce.routing with ospf
```

!
version 15.2
!
enable
conf t


Current configuration : 4027 bytes
!
! Last configuration change at 14:10:37 UTC Sat May 10 2014
!
version 15.4
no service timestamps debug uptime
no service timestamps log uptime
no platform punt-keepalive disable-kernel-core
interface Ethernet0/1
 no shut
exit
!
hostname R5
!
boot-start-marker
boot-end-marker
!
!
!
no aaa new-model
!
ip vrf VPN_A
 rd 100:1
 export map VPN_A_EXPORT
 route-target export 100:1
 route-target import 100:1
 route-target import 100:66
!
ip vrf VPN_B
 rd 100:2
 route-target export 100:2
 route-target import 100:2
!
!
!
!
!
!
!


no ip domain lookup
!
!
!
ipv6 unicast-routing
!
!
!
!
!
!
!
subscriber templating
!
mpls ldp password required
mpls ldp neighbor 150.1.4.4 password CISCO
no mpls ldp advertise-labels
mpls ldp advertise-labels for 10
multilink bundle-name authenticated
!
!
license udi pid CSR1000V sn 9Y9VCZ8B841
license boot level premium
spanning-tree extend system-id
!
!
redundancy
 mode none
!
!
!
!
!
cdp run
!
! 
!
!
!
!
!
crypto isakmp policy 10
 encr aes
 hash md5
 authentication pre-share
 group 5
crypto isakmp key cisco address 0.0.0.0        
!
!
crypto ipsec transform-set ESP_AES_SHA esp-aes esp-sha-hmac 
 mode tunnel
!
crypto ipsec profile DMVPN_PROFILE
 set transform-set ESP_AES_SHA 
!
!
!
!
!
!
! 
! 
!
interface Loopback0
 ip address 150.1.5.5 255.255.255.255
 ipv6 address 2001:150:5:5::5/128
!
interface Loopback101
 ip vrf forwarding VPN_A
 ip address 172.16.5.5 255.255.255.0
!
interface Tunnel0
 ip address 155.1.0.5 255.255.255.0
 no ip redirects
 ip mtu 1400
 ip nhrp authentication NHRPPASS
 ip nhrp map multicast dynamic
 ip nhrp network-id 1
 ip tcp adjust-mss 1360
 delay 1000
 mpls ip
 tunnel source Ethernet0/1.100
 tunnel mode gre multipoint
 tunnel key 150
 tunnel protection ipsec profile DMVPN_PROFILE
!
interface Ethernet0/1
 no ip address
 negotiation auto
 cdp enable
!
interface Ethernet0/1.5
 encapsulation dot1Q 5
 ip vrf forwarding VPN_B
 ip address 155.1.5.5 255.255.255.0
 ipv6 address 2001:155:1:5::5/64
!
interface Ethernet0/1.45
 encapsulation dot1Q 45
 ip address 155.1.45.5 255.255.255.0
 ipv6 address 2001:155:1:45::5/64
 mpls ip
!
interface Ethernet0/1.58
 encapsulation dot1Q 58
 ip vrf forwarding VPN_B
 ip address 155.1.58.5 255.255.255.0
 ipv6 address 2001:155:1:58::5/64
!
interface Ethernet0/1.100
 encapsulation dot1Q 100
 ip address 169.254.100.5 255.255.255.0
 ipv6 address 2001:169:254:100::5/64
!
interface GigabitEthernet2
 no ip address
 shutdown
 negotiation auto
!
interface GigabitEthernet3
 no ip address
 shutdown
 negotiation auto
!
router ospf 1
 router-id 150.1.5.5
 network 150.1.0.0 0.0.255.255 area 0
 network 155.1.0.0 0.0.255.255 area 0
!
router rip
 version 2
 no auto-summary
 !
 address-family ipv4 vrf VPN_B
  redistribute bgp 100 metric transparent
  network 155.1.0.0
  no auto-summary
 exit-address-family
!
router bgp 100
 bgp log-neighbor-changes
 no bgp default ipv4-unicast
 neighbor 150.1.4.4 remote-as 100
 neighbor 150.1.4.4 update-source Loopback0
 !
 address-family ipv4
 exit-address-family
 !
 address-family vpnv4
  neighbor 150.1.4.4 activate
  neighbor 150.1.4.4 send-community extended
 exit-address-family
 !
 address-family ipv4 vrf VPN_A
  redistribute connected
  redistribute static
 exit-address-family
 !
 address-family ipv4 vrf VPN_B
  redistribute connected
  redistribute static
  redistribute rip
 exit-address-family
!
!
virtual-service csr_mgmt
!
ip forward-protocol nd
!
no ip http server
no ip http secure-server
!
!
ip prefix-list LO101 seq 5 permit 172.16.5.0/24
access-list 10 permit 150.1.0.0 0.0.255.255
!
route-map VPN_A_EXPORT permit 10
 match ip address prefix-list LO101
 set extcommunity rt 100:55
!
route-map VPN_A_EXPORT permit 20
 set extcommunity rt 100:1
!
mpls ldp router-id Loopback0 force
!
!
control-plane
!
!
line con 0
 exec-timeout 0 0
 privilege level 15
 logging synchronous
 stopbits 1
line aux 0
 stopbits 1
line vty 0
 privilege level 15
 no login
line vty 1
 privilege level 15
 no login
 length 0
line vty 2 4
 privilege level 15
 no login
!
!
end

R5#
!
end



```