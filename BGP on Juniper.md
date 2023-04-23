
cisco: show ip route

juniper

# view IP routing
show | display set | no-more 

should configure default route - static route 0.0.0.0/0 next-hop 192.168.20.1
# just default routes configured
set routing options static route 0.0.0.0/0 next-hop 192.168.20.1

Vlans on switch 

configure interface:
set interfaces ge-0/0/0.o family inet address 10.10.10/30

###############


login: root

# view configuration
show configuration | display set

show route

// irb.10 = routable interface or the vlan interface  

## configure ospf - area 0 : backbone
ensure mtu is the same on both routers: esp when OSPF is stuck on ExStart state
// set 


root@ROUTER-A>edit
edit 

top edit protocos ospf # if you want to move top of hierachy

edit protocos ospf 
# show # to view any config
set area 0.0.0.0
# alternatively
set area 0 interface xe-0/0/1.0  # set interface to enable  
show # similar to: sh run | ospf
commit

run show ospf neighbor


top edit protocols ospf
show
<!-- # addd extra interface
set area 0 interface irb.10
run show route
top edit protocols ospf
delete area 0 interface irb.10
show
commit -->


edit policy-options

# use route to export to OSPF the interface  interface irb.10 whose ip is 192.168.1.0/24
set policy-statement OSPF-EXPORT from route-filter  192.168.2.0/24 exact
event OSPF-EXPORT then accept
show

top edit protocols ospf

set export OSPF-EXPORT
show | compare
commit
   

## repeat the same on different router - site b

```shell
edit 
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

# top edit protocols ospf
# show
# set area 0 interface irb.10
# commit

# run show route

# top edit protocols ospf
# delete area 0 interface irb.10
# show
# commit

edit policy-options

# use route to export to OSPF the interface  interface irb.10 whose ip is 192.168.1.0/24
set policy-statement OSPF-EXPORT from route-filter  192.168.1.0/24 exact
event OSPF-EXPORT then accept
show

top edit protocols ospf

set export OSPF-EXPORT
show | compare
commit

# from the other router we should now be able to learn the route via OSPF

## show ip route table
run show route


```


## configure interfaces:

edit interfacaes xe-0/0/1



192.168.1.0/24


10.10.10.1/32 - 
169.254.0.2/32

###


  [SIT-A] ==========[SITE-B]
 192.168.10.0/24     192.168.20.0/24


1. configure the interfaces between the two routers

root@SITE-A-ROUTER# 

set interfaces ge-0/0/0.0 family inet address 10.10.10.1/30

2. use and IGP to advertise the peering network interfaces(in this case the loopbacks) to each router 
set interfaces ge-0/0/0 unit family iso
set interfaces ge-0/0/0 description " uplink  Router B"

3. configure the interfaces to the switch(our local LAN )
set interfaces ge-0/0/1 unit 0 family inet address 192.168.10.1/24
set interfaces ge-0/0/1 description "Uplink to switch A"
commit

# you should now be able to ping the switch: the switch has the following ip with a default of 192.169.10.1
ping 192.168.10.10

// add a loopback interface to used as the update-source in BGP and enable IGP on it(IS-IS or OSPF)

set interfaces lo0.0 family inet address 172.16.0.1/32

// 49.0001.0172.0016.0001.00 => 0172.0016.0001.00 can be any number just mapping the loopback for ease of identificaiton
set interfaces lo0.0 family iso address 49.0001.0172.0016.0001.00
edit protocals isis
set interface ge-0/0/0.0 level 1 disable
// we don't want our loopback to participate in routing decisions hence we make it passive: ospf passive int?
set interface lo0.0 passive
show
commit
 
// view our config:[CISCO] show run | s isis | interface ge-0/0/0.0 
show | display set | no-more

copy the config and modify to load by paste to other routers.



## ROUTER B

root@SUTE-B-ROUTER#
set interfaces ge-0/0/0 description " uplink  Router A"
set interfaces ge-0/0/0.0 family inet address 10.10.10.2/30
set interfaces ge-0/0/0 unit family iso
set interfaces ge-0/0/1 description "Uplink to switch B"
set interfaces ge-0/0/1 unit 0 family inet address 192.168.10.1/24
set interfaces lo0.0 family inet address 172.16.0.2/32
set interfaces lo0.0 family iso address 49.0001.0172.0016.0002.00
set interface ge-0/0/0.0 level 1 disable
set interface lo0.0 passive

commit
show | display set | no-more

# now is is adjancy or IGP routing should be up before we configure bgp: test on both routers
show run isis adjacency
run show route

## iBGP configuration

on Router A
edit protocols bgp group IBGP
show
# set bgp as interan iBGP  
set type internal
set local-address 172.16.0.1
set neighbor 172.16.0.2
// set as private as -
set local-as 65535
commit
show | display set


## configure iBGP on Router

set protocals bgp group IBGP tpe internal
set protocals bgp group IBGP local-address 172.16.0.2
set protocals bgp group IBGP local-as 65535
set protocals bgp group IBGP neighbor 172.16.0.1

commit

show | display set

run show bgp summary

# configure the export and import policy to redistribute prefixes to other peering routers networks to BGP
# note the routes we want to advertise must be already installed on our routing table -eg directly connected interface( in this case we have 192.168.10.0/24 direct on local gig)
top
run show route


commit
top edit policy-options policy-statement IBGP-EXPORT
set from protocal direct
set from route-filter 192.168.10.0/24 exact
set then accept

top
show | compare

top edit protocols bgp group IBGP
show
// apply the route-map
set export IBGP-EXPORT
top
commit

show run bgp summary

show
show | display set

run show route receive-protocal bgp 172.16.0.1


// copy the route-map policy and paste to router b



# on Router B

set policy-options policy-statement IBGP-EXPORT from protocal direct
set policy-options policy-statement IBGP-EXPORT from route-filter 192.168.2 0.0/24 exact
set policy-options policy-statement IBGP-EXPORT then accept
commit 

set export IBGP-EXPORT
set export IBGP-EXPORT
COMMIT
run show bgp summary
// check received routes from the bgp peer 172.16.0.2
run show route receive-protocal bgp 172.16.0.2

now you can test connectivity from your internal pc or lan to remote as

  

### ROUTE REFLECTORS ON JUNIPER 

RA#
edit protocals bgp group IBGP-SERVERS
set type internal
set neighbor 172.16.0.255
set neighbor 172.16.0.254
set local-as 65535
set local-address 172.16.0.1
show
commit


RA#
edit protocals bgp group IBGP-SERVERS
set type internal
set neighbor 172.16.0.255
set neighbor 172.16.0.254
set local-as 65535
set local-address 172.16.0.2
show
commit

RR-1# route reflector
top edit protocols bgo group IBGP-CLIENTS
set cluster 1.1.1.1
set type internal
set neighbor 172.16.0.1
set neighbor 172.16.0.2
set local-as 65535
set local-address 172.16.0.255
show
commit
run show bgp neighbor



RR-2# route reflector(cluster id must be the same for same RR cluster)
top edit protocols bgo group IBGP-CLIENTS
set cluster 1.1.1.1
set type internal
set neighbor 172.16.0.1
set neighbor 172.16.0.2
set local-as 65535
set local-address 172.16.0.254
set
commit
show
run show bgp neighbor

// IF YOU MISSPELLED: replace patter IBG-CLIENTS with IBGP-CLIENTS