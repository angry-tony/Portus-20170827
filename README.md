portus & registry server : pdr-01 = 192.0.220.105
ldap server : 192.0.220.101

Containers (portus & registry server) must have portus-CA.crt to communicate
- add crt file to container
- add "192.0.220.105 pdr-01" to container's /etc/hosts file
