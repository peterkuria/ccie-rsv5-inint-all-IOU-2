Sure, here's the full Juniper configuration to redistribute as per the updated requirements:

```
interfaces {
    ge-0/0/0 {
        unit 0 {
            family inet {
                address 172.16.0.6/30;
            }
        }
    }
    xe-0/0/0 {
        unit 0 {
            family inet {
                address 192.168.1.1/24;
            }
        }
    }
    xe-0/1/3 {
        unit 0 {
            family inet {
                address 172.16.0.2/30;
            }
        }
    }
}

routing-options {
    router-id 10.0.0.1;
}

protocols {
    ospf {
        area 0.0.0.0 {
            interface xe-0/0/0.0 {
                passive;
                metric 10;
            }
            interface xe-0/1/3.0 {
                passive;
                metric 10;
            }
        }
    }

    bgp {
        group ebgp {
            type external;
            multihop {
                ttl 3;
            }
            export export-to-ospf;
            neighbor 172.16.0.5 {
                remote-as 2;
            }
            neighbor 172.16.0.1 {
                remote-as 3;
            }
        }
        group ibgp {
            type internal;
            export export-to-ospf;
            neighbor 10.0.0.2 {
                peer-as 1;
            }
            neighbor 10.0.0.3 {
                peer-as 1;
            }
        }
        group rr {
            type internal;
            cluster 1;
            neighbor 10.0.0.2 {
                remote-as 1;
                route-reflector-client;
            }
            neighbor 10.0.0.3 {
                remote-as 1;
                route-reflector-client;
            }
        }
    }
}

policy-options {
    policy-statement export-to-ospf {
        from protocol bgp;
        then {
            as-path-prepend "2 ";
            route-filter 0.0.0.0/0 prefix-length-range /0-/32;
            propagate-nexthop;
            accept;
        }
    }
}
``` 

