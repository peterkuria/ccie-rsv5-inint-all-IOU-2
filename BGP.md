# BGP
Since BGP relies on port TCP 179

show control-plane host open-ports

show tcp tcb
show tcp brief
 
## shows connections bound 

BGP update source is very important: Source traffic from loopback(esp of iBGP), not interface, since IGP maybe pairing using different links. USeful for route reroute incase of link failure

In eBGP peering should be on the connected link

 EBGP TTL(Time to Live) 1(directly connected )

 iBGP TTL 255

 BGP multi-hop and TTL security  

 1. ensure there is routing between the routers

 show ip route


 use ping to test connectivity

 ##
R4#
ping 155.1.45.5

ping 155.1.1.1 source 150.1.4.4
 

can use underlay 

169.254.100.4



conf t
int gig1
  ip address 10.0.0.4 255.255.255.0
  no shut

  do ping 10.0.0.100 
  end


r4# monitor capture 1 match any
monitor cature 1 int gig1.45 both
monitor capture 1 start

show monitor cap 1 buffer

# export packet capture
monitor capture 1 export tfpt://10.0.0.100/r4.bgp.pcap


monitor capture 1 stop
monitor capture 1 clear
monitor capture 1 start





conf t
  router bgp 4.4
  neighbor 155.1.45.5 remote-as 5.5
  neighbor 
  end
## on r5

conf t
  router bgp 5.5
  bgp asnotation dot
  timers bgp 5 15

  neighbor 155.1.45.4 remote-as 4.4
  end

show run | asnotation | s bgp
show ip bgp summary
// neighbor should be up up - not down or never
test

show ip bgp neighbors


  bgp asnotation dot = to show us as in decimal insted of byte


Ensure BGP peering has been established - 
timers - used- negotiated

# SOft reset of bgp - not distuptive
clear ip bpg * out
clear ip bgp * in

## or better just the neighbor
clear ip bgp 155.1.45.5 in

## DO NOT DO THIS IN PRODUCTION - HARD RESET
// clear ip bgp * 
clears all bgp tcp transport and regenerate - tcp connection it will drop traffic

show ip bgp neighbor


## iBGP peering using connected links
// sourcing traffic in iBGP

TCP  client and TCP server



r1# 
conf t 
  router bgp 4.4
  neighbor 150.1.4.4 update-source lo0
  end


in MPLS it is required the update source loopack be a /32 host route  

#  exsi packet wireshartk server 
 
## you can enable access list must be both ways for client and server


R1#
ip access-list ex R4_TO_R1_BGP

permit tcp host 150.1.1.1 host 150.1.4.4 eq 179
permit tcp host 150.1.1.1 eq 179 host 150.1.4.4



## to view config

sh run | s bgp

## BGP ORM


## EBGP multihop
For EBGP
if the routers are not directly connected we need to increase the TTL

EBGP packets default to TTL 1
neighbor ebgp-multihop [ttl]
neighbor ttl-security hops [ttl]

eg. in our case:

// neighbor ebgp-multihop 2

## better implementation
neighbor ttl-security hops [ttl]



# being permissive


ip access-list ex BGP
permit tcp host any any eq 179
permit tcp any eq 179 host any

monitor cature 1 access-list BGP
monitor capture 1 start
show monitor cap 1 buffer

clear ip bgp *
monitor capture 1 export tfpt://10.0.0.100/r4.bgp.pcap

monitor capture 1 stop
monitor capture 1 clear



r4# 
conf t
  router bgp 4.4
  neighbor 150.1.1.1 transport connection-mode passive
  neighbor 150.1.1.1 update-source lo0
  neighbor 155.1.45.5 ebgp-multihop 100
  end


clear ip bgp * 


## using ttl-security instead of ebgp multi-hop(cannot use with multihp)
// setting TTL to 255 by setting ttl-security 1
r4# 
conf t
  router bgp 4.4
  neighbor 155.1.45.5 transport connection-mode passive
  neighbor 155.1.45.5 update-source lo0
  neighbor 155.1.45.5 ttl-security 2
  end



r5# 
conf t
  router bgp 5.5
  neighbor 155.1.45.4 update-source lo0

  neighbor 155.1.45.4 transport connection-mode passive
  neighbor 155.1.45.4 ttl-security 2
  end

// ipv4 address
rviews/ oregon AT&T, optus, he.net, gbix 
rviews> trace www.cisco.com

// force to trace using ipv4
trace ip cisco.com


non multi-hop peers must be directly connected by default:
- can be modified if connected neighbors peer via Loopbacks
- neighbor disable-connected-check



r4# show ip route 150.1.5.5
traceroute 150.1.5.5


    
<!-- // count the number of hops
r4# traceroute 150.1.5.5


conf t
  router bgp 4
  neigbor 150.1.5.5 remote-as 5
  neighbor 150.1.5.5 update-source lo0
5  end



r5# 
conf t
  router bgp 5
  neighbor 150.1.4.4 remote as 4
  neighbor 150.1.4.4 update-source lo0
  end -->


  iBGP Loop Prevention

  OSPF fast convergence
 
  ospf Roop free altenate
 ospf bidirection protection 
 ospf timers for fast convergence

 in OSPF, if an advertised link drops will withdraw the LSA by flooding it and setting max age

 By default do not modify nexhop behaviour - outbound iBGP updates do not modify the NH  

 EBGP - by default outbound EBGP updates have local update-source for neignbor set as next-hop(modified to itself)
 e.g  update-source is Loopback0, next-hop is Loopback0


r4#
show ip bgp summary

show ip connected



## using ttl-security instead of ebgp multi-hop(cannot use with multihp)
// setting TTL to 255 by setting ttl-security 1

  network 155.1.4.0 mask 255.255.255.0 = means originate the network advertisement(prefix 155.1.4.0/24 on BGP) not enable BGP on link(BGP run on TCP connection on nei)
 

sh


r5# 
conf t
  router bgp 5.5
  network 155.1.5.0 mask 255.255.255.0
  neighbor 155.1.45.4 update-source lo0
  neighbor 155.1.45.5 ebgp-multihop 100
  end


r4# 
conf t
  router bgp 4.4
  network 155.1.4.0 mask 255.255.255.0
  neighbor 155.1.45.5 update-source lo0
  neighbor 155.1.45.5 ebgp-multihop 100

  end

## view adversited perfix
show ip bgp summary

// show ip bgp table: internal status code means its iBGP
show ip bgp


// view AD BGP AD distance is 20, 
show ip route 155.1.5.0


// how do we route to the next-hop: BGP does not tell you how, its IGP role
show ip route 150.1.5.5

// view route on CEF fib table
show ip cef 155.1.5.5 

ping 155.1.5.5 source lo0


tracerout 155.1.5.5 source lo0

view whole routing table
show ip route


debug ip routing


## this will cause RIB failure: route recursion race and you wont be able to route to the prefix 
150.1.5.5
 r5# 
conf t
  // no router bgp x
  router bgp 5.5
  network 155.1.5.0 mask 255.255.255.0
  network 150.1.5.5 mask 255.255.255.255
  neighbor 155.1.45.4 update-source lo0
  neighbor 155.1.45.5 ebgp-multihop 100
  end

// change the distance on R4 for eBGP routes(lower administrative distance): external to higher ther ospf
r4# 
conf t
  router bgp 4.4
  network 155.1.4.0 mask 255.255.255.0
  distance bgp 91 200 1



## Route reflectors

## this will cause RIB failure: route recursion race and you wont be able to route to the prefix 
150.1.5.5

### Route reflector r5 - peering with the neighbors 1-8
 r5# 
conf t
  // no router bgp x
  router bgp 100
  neighbor RR_CLIENTS peer-group
  neighbor RR_CLIENTS remote-as 100
  neighbor RR_CLIENTS update-source lo0
  neighbor RR_CLIENTS route-reflector-client

  neighbor 150.1.4.4 peer-group RR_CLIENTS 
  neighbor 150.1.8.8 peer-group RR_CLIENTS


  network 155.1.5.0 mask 255.255.255.0
  network 150.1.5.5 mask 255.255.255.255
  neighbor 155.1.45.4 update-source lo0
  neighbor 155.1.45.5 ebgp-multihop 100
  end

// change the distance on R4 for eBGP routes(lower administrative distance): external to higher ther ospf
r8# 
no router bgp 100
conf t
  router bgp 100
  bgp log-neighbor-changes
  network 150.1.4.4 mask 255.255.255.255
  neighbor 150.1.5.5 remote-as 100
  neighbor 150.1.5.5 update-source Loopback0
  neighbor 155.1.108.10 remote-as 10

  distance bgp 91 200 1


neighbor 150.1.4.4 peer-group RR_CLIENTS 
neighbor 150.1.8.8 peer-group RR_CLIENTS



// send to all RR clients(R5 is RR)
conf t
router bgp 100
  neighbor 150.1.5.5 remote-as 100
  neighbor 150.1.5.5 update-source loopback0
end

R5#
show ip bgp
show ip bgp regex ^[0-0]+

## Debugging
show run | s bgp
debug ip bgp updates


from RR client try to ping an external destination- sourcing from lo0

R4# ping 15



R8
conf t
router bgp 100
  address-family ipv6 unicast
  bgp cluster-id 150.1.5.5
  neighbor 150.1.2.2 activate
  neighbor 150.1.4.4 activate
  neighbor 150.1.5.5 route-reflector-client
  
show bgp ipv4 unicast summary

show bgp ipv6 unicast summary

##

R9

sh run | s bgp

router bgp 10
  bgp log-neighbor-changes
  network 150.1.10.10 mask 255.255.255.255
  redistribute connected
  neighbor 155.1.108.8 remote-as 100
  neighbor 155.1.109.9 remote-as 9




## using route-map - VD 81 - Vide BGP filtering

conf t

route-map LOOPBACK
  match interface loopback0
!
router bgp 100
  redistribute connected route-map LOOPBACK
end




on external routes

//show routes coming from AS 100
show ip regex _100$ 

P2P uses /30 or /32


BGP manual summarisation

bgp auto-summary

You can apply summarisation anywhere as long as the subnet exists in the BGP table(required on routing table)
aggregate-address [network] [mask] [args]

Ip routing | Cisco Ios routing: BGP command reference
#r1

28.119.16.0 - 00010000
28.119.17.0 - 00010001

/16 + 7 bits(matching) = /23

aggregate is 28.119.16.0/23 


router bgp 100
  aggregate-address 28.119.16.0 255.255.255.254.0
end


show ip bgp | 28.119

show ip bgp neighbors 155.1.158.8 advertised-routes

class A /8
114.0.0.0/8 - 01110010
115.0.0.0/8 - 01110011
118.0.0.0/8 - 01110110

aggregate is 112.0.0.0/5(take least bits, the base is 114)

11111100 into decimal is 248(mask )

router bgp 100
  aggregate-address 112.0.0.0 248.0.0.0
cf first octet and convert the octet into binary

show ip bgp 112.0.0.0/5

classful B /16

classful C/ 24

192.168.45.0/24

Even or odd parity check
BGP Aggregation - IP addressing. the base address is obtained by AND-ing all the 
addresses in a given range
binary: 
128 64 32 16 8 4 2 1
// mask
x    x  x  x x x x 0 => even
x    x  x  x x x x 1 => odd
1    1  1  1 1 1 1 0 => means its an even number 0000000

access-list 1 permit 0.0.0.0 254.255.255.255 => matches even numbers- ip prefixes

// e.g to aggregate to /25: aggregate-address 28.119.16.0 255.255.128.0 

The last bit determines if the number is odd(1) or even(0)

R1#
conf t
  access-list 1 permit 0.0.0.0 254.255.255.255
  route-map SUPPRESS_MAP
    match ip address 1
  router bgp 100
  aggregate-address 112.0.0.0 248.0.0.0 suppress-map SUPPRESS_MAP
end


on external EBGP router such as R8, you will have the routes in bgp table as summarised as 112.0.0.0/5 and the summary as 115.0.0.0

on R1 they will suppressed(s for not being advertised) - cutting down on the BGP table to install on the FIB

should not receive less than /21 from other peers

show ip bgp | in /2[5-9]

R!#
Summary-only: Filter more specific routes from updates
aggregate-address 28.119.16.0 255.255.254.0 summary-only 
summarises the BGP table to advertise only a summmary for the subnet 28.119.16.0/

if there's submet in the BGP table, generate the aggregate(summary) and suppress all the subnets(summary-only)



to modify NH next-hop for iBGP to self - replace remote-as with next-hop-self and `clear ip bgp * in

R5#
conft t
router bgp 200
  // neighbor 155.1.0.5 remote-as 200
  neighbor 155.1.0.5 next-hop-self
  neighbor 1551.58.8 next-hop-self




  ##########################


R4#

router bgp 4
bgp log-neighbor-chan ges
neighbor 155.1.45.5 remote-as 5
neighbor 155.1.45 fall-over bfd

end

show ip int  


R5#
conf t
router bgp 5
redistribute connected


telnet 150.1.5.5
tclsh
//on R4 -issue> neighbor 155.1.45.5 shutdown = temporary turn down bgp session

generate_loopbacks 1000
tclquit


sh run all | sec bgp

## Redistribution

under bgp and ospf do mutual redistribution

R7#
conft t

router bgp 100
address-family ipv4-unicast
redistribute ospf 1

router ospf 1
redistribute bgp 100 subnets



### advertise a new prefix under R9

conf t
int lo9
ip address 9.9.9.9 255.255.255.255
ip ospft 1 area 9
end