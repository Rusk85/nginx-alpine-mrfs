printf "Stopping and deleting previous container...\n"
docker rm -f nginx

printf "\nRunning new container off of latest build...\n"
docker run -d --name nginx -p 80:8080 -ti rusk85/nginx-alpine-mrfs
