> OPERATIONAL MODE

orion 
sol.wananchi.com/orion


# configuration mode


test@SWITCH>configure

Entering configuration mode
test@SWITCH#



login: root
password

# to enter cli you have to type cli and ENTER

# TO ENTER OPERATIONAL MODE
# RE:0% cli

/return to config mode
> edit
run show interfaces terse
show interfaces descriptions

show interfaces terse  => show int bri
// to commit only your config
configure private 

# show
set interfacee xe-0/0/0 description "Test description"

# to precheck commit
commit check

equivalent to showdddddddddddddddddddddd
show | compare

commit confirmed 2

commit

  
rollback 0

# use tab or space for auto

set inteface get


## TO LOAD CONFIGS


load set relative terminal

# paste the config
set system services ssh root-login allow
set system service netcong ssh
set system services rest http port 8080
set system services rest enable-explorer

// PRESS ENTER followed by CTRL+ D

## LOAD JSON config 

# load merge relative terminal


```json

system {
    services {
        ssh {
            root-login allow;

        }
        netconf {
            ssh;
        }

        rest {
            http {
                port 8080;
            }
            enable-explorer;
        }
    }
}

```

press ENTER | CTRL + D

show | compare
commit

show | display set


edit show

// the followoing is similar to: show run | s OSPF BGP, 

show | display set | match system

// to view vlans

show ethernet-switching table

show bridge mac-table
show arp

show arp no-resolve 

# view routing table: show ip route
show route

# packet capture

monitor traffic interface xe-0/0/0

show isis adjaceny
show bgp summary
show ospf neighbor


i have the give me a clean aggegate summary for advertising to bgp

172.16.0.6/30
172.16.0.5/30
172.16.0.1/30
172.16.0.2/30

Here is the updated ip addressing
Router-1 is connected to router-r2 on ge0/0/0 on 172.16.0.6/30.router-2 hs three interaces, ge0/0/0 on 172.16.0.5/30 linking to router 1; ge0/0/0/1 on 192.168.1.254 connecting to a default rout 0.0.0.0/0 to the internet;
and xe0/0/0/35 on 172.16.0.1/30 linking to router-3. router-3 links to router-2 on xe0/1/3 on 172.16.0.2/30
can we have the full juniper configuration to redistribute as per the above requirement


