#!/bin/bash -x

source /host/settings.sh

### start the httpd server with the given admin user and password
cat <<EOF > /etc/monit/conf.d/httpd
set httpd port 2812 and
   use address localhost  # only accept connection from localhost
   allow localhost        # allow localhost to connect to the server
   allow $USER:$PASS
EOF

### send notifications through a gmail account
cat <<EOF > /etc/monit/conf.d/gmail
set mailserver smtp.gmail.com port 587
    username "$GMAIL_ADDRESS" password "$GMAIL_PASSWD"
    using ssl
EOF

### set the email for sending alerts
cat <<EOF > /etc/monit/conf.d/alert
set alert $EMAIL
EOF

### check the system status
cat <<EOF > /etc/monit/conf.d/system
check system $DOMAIN
    if loadavg (15min) > 1 then alert
    if memory usage > 90% for 4 cycles then alert
    if swap usage > 20% for 4 cycles then alert
    if cpu usage (user) > 80% for 2 cycles then alert
    if cpu usage (system) > 20% for 2 cycles then alert
    if cpu usage (wait) > 80% for 2 cycles then alert
    if cpu usage > 95% for 4 cycles then alert
EOF
