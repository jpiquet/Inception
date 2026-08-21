FROM debian:bookworm

RUN apt update && apt install nginx -y && apt install openssl -y

COPY conf/nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon off;"]