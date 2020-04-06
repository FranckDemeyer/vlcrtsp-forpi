FROM balenalib/rpi-alpine

ARG ARCH=armv7l

RUN install_packages git

COPY resources/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
