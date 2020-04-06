FROM balenalib/rpi-alpine:latest

RUN apt-get update -y &&
    apt-get upgrade -y &&
    DEBAIN_FRONTEND=noninteractive
    apt-get install -y vlc

COPY resources/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
