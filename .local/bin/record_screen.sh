#!/bin/bash
OUTFILE=$1
[ -z "$OUTFILE" ] && OUTFILE=screengrab.avi
#ffmpeg -f x11grab -i ${DISPLAY} -c:v mpeg4 -q:v 1 -f alsa -ac 2 -i default -itsoffset 00:00:00.5 -loglevel error $OUTFILE
ffmpeg -f alsa -i hw:1 -f x11grab -s 1920x1080 -i ${DISPLAY} -c:v mpeg4 -q:v 1 $OUTFILE
