FROM balenalib/rpi-alpine:latest

RUN sudo apt-get update -y &&
    sudo apt-get upgrade -y &&
    DEBAIN_FRONTEND=noninteractive
    sudo apt-get install -y vlc

COPY resources/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
