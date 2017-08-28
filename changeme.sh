
mount -t nfs NFSSERVER-IP:/EXPORT-DIR /var/lib/portus/registry

mkdir /var/lib/portus/mariadb/BACKUP

# cronos
sed -i 's/192.0.220.105    pdr-01/192.268.0.0     hoho/g' ~/Portus-20170827/bin/crono

# portus
sed -i 's/pdr-01/HOSTNAME/g' ~/Portus-20170827/.env
sed -i 's/192.0.220.105    pdr-01/192.268.0.0     hoho/g' ~/Portus-20170827/examples/development/compose/init
# ldap
sed -i 's/pdr-01/HOSTNAME/g' ~/Portus-20170827/config/config.yml

# registry
sed -i 's/192.0.220.105    pdr-01/192.268.0.0     hoho/g' ~/Portus-20170827/for-self-crt/registry/init
