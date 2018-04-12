FROM ubuntu:18.04
RUN apt-get update -y && apt-get install -y git python3 wget mysql-client
COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT /entrypoint.sh
