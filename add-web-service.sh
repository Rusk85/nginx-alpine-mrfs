#!/bin/bash
# Add additional web service to nginx.conf

#DEBUG
set -euxo pipefail
#RELEASE
#set -euo pipefail

NGINX_CONF=nginx.conf
APP_NAME=$1
APP_IP=$2
APP_PORT=$3
	
#printf "$APP_CONFIG"

#Calculate position where to insert new config block
OFFSET=1
NGINX_LCOUNT=$(grep -c -e "^" $NGINX_CONF)
INSERT_AT=0
let "INSERT_AT = $NGINX_LCOUNT - $OFFSET"
let "NGINX_LCOUNT"

#Insert new config block before calculated line number
#sed "${INSERT_AT} i $(echo -e ${APP_CONFIG})" $NGINX_CONF > nginx_test.conf
APP_CONFIG=$(cat <<END
	server {
		server_name $APP_NAME.muncic.local;
		listen 0.0.0.0:8080;
		access_log /var/log/nginx/$APP_NAME.log combined;
		location / {
			proxy_set_header Host \$host;
			proxy_set_header X-Real-IP \$remote_addr;
		    	proxy_set_header X-Forwarded-Host \$host;
			proxy_set_header X-Forwarded-Server \$host;
			proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
			proxy_set_header X-Forwarded-Proto \$scheme;
			proxy_pass http://$APP_IP:$APP_PORT;
			proxy_set_header Authorization \$http_authorization;
			proxy_read_timeout 180;
		}
	}
}
END
)

printf "\nAdding new web application to $NGINX_CONF\n"

TMP_FILE=tmp.conf
printf "$APP_CONFIG" > $TMP_FILE

sed -i "${NGINX_LCOUNT} d" $NGINX_CONF

cat $TMP_FILE >> $NGINX_CONF
rm $TMP_FILE

printf "\nFinished!\n"
