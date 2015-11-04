#!/bin/bash
OUTFILE=$1
[ -z "$OUTFILE" ] && OUTFILE=screengrab.avi
#ffmpeg -f x11grab -s 1024x768 -i ${DISPLAY} -c:v mpeg4 -q:v 1 -f alsa -ac 2 -i default -itsoffset 00:00:00.5 -loglevel error $OUTFILE
ffmpeg -f x11grab -s 1024x768 -i ${DISPLAY} -c:v mpeg4 -q:v 1 -loglevel error $OUTFILE
