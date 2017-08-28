
mount -t nfs NFSSERVER-IP:/EXPORT-DIR /var/lib/portus/registry

mkdir /var/lib/portus/mariadb/BACKUP

examples/development/compose/create-crt.sh

# cronos
sed -i 's/192.0.220.105    pdr-01/192.268.0.0     hoho/g' ~/Portus-20170827/bin/crono

# portus
sed -i 's/pdr-01/HOSTNAME/g' ~/Portus-20170827/.env
sed -i 's/192.0.220.105    pdr-01/192.268.0.0     hoho/g' ~/Portus-20170827/examples/development/compose/init
# ldap
sed -i 's/pdr-01/HOSTNAME/g' ~/Portus-20170827/config/config.yml

# registry
sed -i 's/192.0.220.105    pdr-01/192.268.0.0     hoho/g' ~/Portus-20170827/for-self-crt/registry/init


for i in bootstrap-ldap-nfs-01 pdr-01 master-01 pri-slave-01 pub-slave-01; do ssh $i "rm -rf /etc/pki/ca-trust/source/anchors/*"; done

for i in bootstrap-ldap-nfs-01 pdr-01 master-01 pri-slave-01 pub-slave-01; do scp pdr-01:/root/docker-auth-bearer-ldap-setup/certs/pdr-01-CA.crt $i:/etc/pki/ca-trust/source/anchors; done

for i in bootstrap-ldap-nfs-01 pdr-01 master-01 pri-slave-01 pub-slave-01; do ssh $i "update-ca-trust force-enable && update-ca-trust enable && update-ca-trust extract"; done

cat /etc/pki/ca-trust/source/anchors/pdr-01-CA.crt >> /opt/mesosphere/active/python-requests/lib/python3.5/site-packages/requests/cacert.pem



#################
# mysqldump -uroot -pportus12341234 --all-databases > /var/lib/portus/mariadb/BACKUP/backup.sql
# mysql -uroot -pportus12341234 < backup.sql

cat > /root/HPE/mysqldump.sh << 'EOF'
#!/bin/sh
DATE=`date +"%Y%m%d%H%M"`
USERNAME="root"
PASSWORD="portus"

docker exec portus20170827_db_1 mysqldump -u${USERNAME} -p${PASSWORD} --all-databases > /var/lib/portus/mariadb/BACKUP/backup.${DATE}.sql
docker exec portus20170827_db_1 ls /var/lib/mysql/BACKUP/backup.${DATE}.sql
# must execute below command in db container to restore db
# docker exec portus20170827_db_1 mysql -u${USERNAME} -p${PASSWORD} < /var/lib/portus/mariadb/BACKUP/backup.${DATE}.sql
EOF

chmod 755 /root/HPE/mysqldump.sh

echo '10 01 * * * root /root/HPE/mysqldump.sh' /etc/crontab
systemctl restart cron
