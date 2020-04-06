FROM balenalib/rpi-alpine:latest

RUN install_packages vlc

COPY resources/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
