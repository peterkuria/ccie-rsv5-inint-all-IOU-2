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
                address 192.168.1.253/24;
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
    router-id 192.168.1.253;
}

protocols {
    bgp {
        group rr-group {
            type internal;
            local-address 172.16.0.6;
            family inet {
                unicast {
                    prefix-limit maximum 10000;
                }
            }
            peer-as 65002;
            neighbor 172.16.0.5 {
                description "Link to Router 2";
                import [ ospf-to-bgp inet-vpn-to-bgp ];
                export [ bgp-to-ospf bgp-to-inet-vpn ];
            }
            neighbor 172.16.0.1 {
                description "Link to Router 3";
                multihop {
                    ttl 3;
                }
                import [ ospf-to-bgp inet-vpn-to-bgp ];
                export [ bgp-to-ospf bgp-to-inet-vpn ];
            }
        }
    }
    ospf {
        export ospf-to-bgp;
        import [ bgp-to-ospf ];
        area 0.0.0.0 {
            interface ge-0/0/0.0 {
                passive;
            }
            interface xe-0/1/3.0 {
                passive;
            }
        }
    }
}

policy-options {
    policy-statement ospf-to-bgp {
        term 1 {
            from protocol ospf;
            then {
                community add no-advertise;
                metric 100;
                accept;
            }
        }
    }
    policy-statement bgp-to-ospf {
        term 1 {
            from protocol bgp;
            then {
                metric 10;
                accept;
            }
        }
    }
    policy-statement bgp-to-inet-vpn {
        term 1 {
            from protocol bgp;
            then {
                community add inet-vpn;
                accept;
            }
        }
    }
}

communities {
    no-advertise members 64512:666;
    inet-vpn members target:65002:666;
}
