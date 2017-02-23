Description
-----------

This is a nginx installation based on alpine linux mini-root-filesystem.
nginx is configured to act as a reverse proxy for currently statically defined servers on my local network. The subdomain pattern is as such:
app1.domain.lan

Usage
-----

Not much can be done with this image unless the nginx.conf is manually edited and nginx then started. In order to do so, follow these steps

	$ docker run -ti -p 80:8080 rusk85/nginx-alpine-mrfs /bin/sh
	$ vi nginx.conf

I marked the lines that need to be changed for successful adaption with a `<-!`:

	   upstream jira {
	           server 192.168.1.35:8585; # <-!
	   }
	
	   server {
	           server_name jira.muncic.local; # <-!
	           listen 8080;
	           access_log /var/log/nginx/jira.log combined;
	           location / {
	                   proxy_set_header Host $host;
	                   proxy_set_header X-Real-IP $remote_addr;
					   proxy_set_header X-Forwarded
					   proxy_add_x_forwarded_for;
					   proxy_pass http://192.168.1.35: # <-!
					   proxy_set_header Authorization "";
	           }
	   }

Once edited, save the configuration and start nginx like so:
			
	$ nginx

Contact
-------

In case you have question, contact me via email:
	
[Rusk85](mailto:troggs@gmx.net)
