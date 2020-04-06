FROM balenalib/raspberry-pi

RUN apt-get update -y &&
   	apt-get install -y vlc &&
	apt-get clean &&
	rm -rf /var/lib/apt/list/

COPY resources/entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
