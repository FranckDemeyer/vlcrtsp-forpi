#!/bin/bash

######################
## GLOBAL VARIABLES ##
######################

DEVICE=
PORT=8554
URL="unicast"
AUDIO=
TRANSCODE="{vcodec=h264,vb=1500,thread=4}"
CACHE=2500

###############
## FUNCTIONS ##
###############

usage() {
	echo "Usage: $0 [options]:"
	echo ""
	echo "    -d=DEVICE, --device=DEVICE                    set the video device to use to DEVICE (e.g.: /dev/video0"
	echo "    -a, --audio                                   set the audio device to on with default value (hw:1,0)"
	echo "    -ad=AUDIO-DEVICE, --audio-device=AUDIO-DEVICE set the audio device to on with value AUDIO-DEVICE (e.g.: hw:2,1)"
	echo "    -c=CACHE, --cache=CACHE                       set the cache time in ms (default 2500)"
}

################
## CHECK ARGS ##
################

for args in "$@"
	do
		case $args in
			-d=*|--device=*)        DEVICE="${args#*=}";;
      			-a|--audio)             AUDIO=":input-slave=alsa://hw:1,0";;
      			-ad=*|--audio-device=*) AUDIO=":input-slave=alsa://${args#*=}";;
			-c=*|--cache=*)         CACHE="${args#*=}";;
      			-h|--help|*)            usage;;
   		 esac
done

# verifying if video device is set
if [[ "$DEVICE" == "" ]]; then
  	echo "[$(date +%d/%m/%Y) $(date +%H:%M)] video device value has been setted to empty" >> errors.log
  	exit 1
fi

# verifying if video device is correctly set
if [[ $(echo "$DEVICE" | egrep -o '/dev/video[[:digit:]]') == "" ]]; then
	echo "[$(date +%d/%m/%Y) $(date +%H:%M)] video device value has been setted badly, value should complain format /dev/video{x} where {x} is the video device number'" >> errors.log
	exit 2
fi

# verifying if the audio device is set and correctly set
if [[ "$AUDIO" != "" ]]; then
	if [[ $(echo "$AUDIO" | egrep -o '//hw:[[:digit:]],[[:digit:]]') == "" ]]; then
		echo "[$(date +%d/%m/%Y) $(date +%H:%M)] audio device value has been setted badly, value should complain format //hw{x},{y} where {x} is the card number and {y} the submodule number" >> errors.log
		exit 3
       	fi
	TRANSCODE="{vcodec=h264,vb=1500,acodec=mp4a,ab=96,channels=2,samplerate=44100,thread=4,audio-sync=1}"
fi

# verifying if cache is correctly set
if [[ $(echo "$CACHE" | egrep -o '[[:digit:]]+') == "" || $CACHE > 60000 ]]; then
	echo "[$(date +%d/%m/%Y) $(date +%H:%M)] cache has been setted badly, value will be changed for 2500ms" >> errors.log
	CACHE=2500
fi

##########
## MAIN ##
##########

cvlc -vvv v4l2://$DEVICE $AUDIO --live-caching=$CACHE --sout "#transcode${TRANSCODE}:rtp{sdp=rtsp://:${PORT}/${URL}}"
