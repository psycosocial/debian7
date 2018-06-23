apt-get install stunnel4 -y
wget -O /etc/stunnel/stunnel.conf "https://raw.githubusercontent.com/psycosocial/debian7/master/stunnel.conf"
cd /etc/stunnel
openssl genrsa -out key.pem 2048
openssl req -new -x509 -key key.pem -out cert.pem -days 1095
cat key.pem cert.pem >> /etc/stunnel/stunnel.pem
sed -i 's/ENABLED=0/ENABLED=1/g' /etc/default/stunnel4
cd
rm ssl.sh
/etc/init.d/stunnel4 restart
