FROM balenalib/rpi-alpine

RUN install_packages git

COPY resources/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
