telnet: 
Switch>en 
Switch#config t
Enter configuration commands, one per line. End with CNTL/Z.
Switch(config)#interface vlan1
Switch(config-if)#ip address 192.168.0.1 255.255.255.0
Switch(config-if)#no shut

Switch(config)#line vty 0 15
Switch(config-line)#password fast
Switch(config-line)#login
Switch(config-line)#end
Switch#config t
Enter configuration commands, one per line. End with CNTL/Z.
Switch(config)#enable password fast
Switch(config)#exit
Switch#
%SYS-5-CONFIG_I: Configured from console by console
telnet 192.168.0.1






SSH:
Switch>en 
Switch#config t
Enter configuration commands, one per line. End with CNTL/Z.
Switch(config)#interface vlan 1
Switch(config-if)#ip address 192.168.0.1 255.255.255.0
Switch(config-if)#no shut
Switch(config-if)#exit

Switch(config)#hostname daniyal
daniyal(config)#ip domain name practice 
daniyal(config)#crypto key generate rsa
The name for the keys will be: daniyal.practice
Choose the size of the key modulus in the range of 360 to 4096 for your
General Purpose Keys. Choosing a key modulus greater than 512 may take
a few minutes.

How many bits in the modulus [512]: 1024
% Generating 1024 bit RSA keys, keys will be non-exportable...[OK]

daniyal(config)#ip ssh version 2
*Mar 1 0:1:20.501: %SSH-5-ENABLED: SSH 1.99 has been enabled
daniyal(config)#line vty 0 15
daniyal(config-line)#password fast
daniyal(config-line)#transport input ssh
daniyal(config-line)#exit

daniyal(config)#enable password fast
daniyal(config)#exit


ssh -l admin 192.168.0.1


















ACL
Block to 10.0.0.2:
Router#config t 
Enter configuration commands, one per line. End with CNTL/Z.
Router(config)#ip access-list extended BLOCK
Router(config-ext-nacl)#deny icmp host 40.0.0.2 host 10.0.0.2 echo
Router(config-ext-nacl)#deny icmp host 30.0.0.2 host 10.0.0.2 echo
Router(config-ext-nacl)#permit ip any any 
Router(config-ext-nacl)#exit
Router(config)#interface fa1/0
Router(config-if)#ip access-group BLOCK out
Router(config-if)#exit 
Router(config)#exit
Router#
%SYS-5-CONFIG_I: Configured from console by console
Block from 10.0.0.2
Router#config t
Enter configuration commands, one per line. End with CNTL/Z.
Router(config)#ip access-list extended block
Router(config-ext-nacl)#deny icmp host 10.0.0.2 host 40.0.0.2 echo
Router(config-ext-nacl)#deny icmp host 10.0.0.2 host 30.0.0.2 echo
Router(config-ext-nacl)#permit ip any any
Router(config-ext-nacl)#exit
Router(config)#interface fa1/0
Router(config-if)#ip access-group block in
Router(config-if)#exit
Router(config)#exit
Router#
%SYS-5-CONFIG_I: Configured from console by console

Block whole network:
Router#config t
Enter configuration commands, one per line. End with CNTL/Z.
Router(config)#ip access-list extended student
Router(config-ext-nacl)#deny icmp 192.168.0.0 0.0.0.255 any echo
Router(config-ext-nacl)#permit ip any any
Router(config-ext-nacl)#exit
Router(config)#interface fa0/0
Router(config-if)#ip access-group student out
Router(config-if)#exit
Router(config)#exit
Router#
Packet Tracer Routing Protocol Codes (No Formatting)








RIP Configuration (RIPv2)
-----------------------------------
Topology Example
R1 — R2 — R3
Networks:
R1: 10.0.0.0/24
R2: 20.0.0.0/24
R3: 30.0.0.0/24
R1
conf t
router rip
version 2
no auto-summary
network 10.0.0.0
network 20.0.0.0
end

R2
conf t
router rip
version 2
no auto-summary
network 10.0.0.0
network 20.0.0.0
network 30.0.0.0
end

R3
conf t
router rip
version 2
no auto-summary
network 20.0.0.0
network 30.0.0.0
end


OSPF Configuration
-----------------------------------
Example Topology
R1: 1.1.1.1 loopback
All routers in Area 0
R1
conf t
router ospf 1
router-id 1.1.1.1
network 10.0.0.0 0.0.0.255 area 0
network 192.168.1.0 0.0.0.255 area 0
end

R2
conf t
router ospf 1
router-id 2.2.2.2
network 10.0.0.0 0.0.0.255 area 0
network 20.0.0.0 0.0.0.255 area 0
end

R3
conf t
router ospf 1
router-id 3.3.3.3
network 20.0.0.0 0.0.0.255 area 0
network 30.0.0.0 0.0.0.255 area 0
end




BGP Configuration
-----------------------------------
Example Topology
R1 (AS 100) — R2 (AS 200)

R1 (AS 100)
conf t
router bgp 100
bgp router-id 1.1.1.1
neighbor 192.168.12.2 remote-as 200
network 10.0.0.0 mask 255.255.255.0
end

R2 (AS 200)
conf t
router bgp 200
bgp router-id 2.2.2.2
neighbor 192.168.12.1 remote-as 100
network 20.0.0.0 mask 255.255.255.0
end


