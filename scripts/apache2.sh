#!/bin/bash -x

source /host/settings.sh

### limit the memory size of apache2
sed -i /etc/apache2/mods-available/mpm_prefork.conf \
    -e '/^<IfModule/,+5 s/StartServers.*/StartServers 1/' \
    -e '/^<IfModule/,+5 s/MinSpareServers.*/MinSpareServers 1/' \
    -e '/^<IfModule/,+5 s/MaxSpareServers.*/MaxSpareServers 2/' \
    -e '/^<IfModule/,+5 s/MaxRequestWorkers.*/MaxRequestWorkers 5/'

### setup the configuration for monit
cat <<EOF > /etc/apache2/sites-available/monit.conf
<VirtualHost *:80>
    ServerName $DOMAIN
    RedirectPermanent / https://$DOMAIN/
</VirtualHost>

<VirtualHost *:443>
    ServerName $DOMAIN
    ProxyPass / http://127.0.0.1:2812/

    SSLEngine on
    SSLOptions +FakeBasicAuth +ExportCertData +StrictRequire
    SSLCertificateFile        /etc/ssl/certs/ssl-cert-snakeoil.pem
    SSLCertificateKeyFile   /etc/ssl/private/ssl-cert-snakeoil.key
    #SSLCertificateChainFile  /etc/ssl/certs/ssl-cert-snakeoil.pem
</VirtualHost>
EOF
### we need to refer to this apache2 config by the name "$DOMAIN.conf" as well
ln /etc/apache2/sites-available/{monit,$DOMAIN}.conf

### update config and restart apache2
a2enmod ssl proxy proxy_http rewrite
a2ensite monit
a2dissite 000-default
service apache2 restart
