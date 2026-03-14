FROM ubuntu:24.04

WORKDIR /usr/src/prout

COPY script.sh .

RUN chmod +x script.sh

RUN apt update && apt install curl -y

ENTRYPOINT ["./script.sh"]

