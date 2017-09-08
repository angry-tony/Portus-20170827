openssl genrsa -out portus-CA.key 4096
openssl req -x509 -new -nodes -key portus-CA.key -sha256 -days 3650 -out portus-CA.crt -subj '/C=XX/L=Default City/O=Default Company Ltd'
openssl genrsa -out portus.key 4096

openssl req -new -sha256 -key portus.key -out portus.csr -subj '/C=KO/ST=Gyeonggi/L=City/O=Company, INC./OU=Team/CN=ldap-nfs-01'

echo 'subjectAltName=DNS:ldap-nfs-01,IP:192.168.147.14' > extfile.cnf
openssl x509 -req -sha256 -in portus.csr -CA portus-CA.crt -CAkey portus-CA.key -CAcreateserial -out portus.crt -days 3650  -extfile extfile.cnf
