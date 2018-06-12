FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y nginx
ADD nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /var/www/
ADD index.html /var/www/index.html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
