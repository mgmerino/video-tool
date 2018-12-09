#!/bin/bash

OUTPUT_FOLDER="output"
CFG_FOLDER="config"
RSC_FOLDER="resources"

FONT_FILE="$RSC_FOLDER/fonts/Roboto_Mono/RobotoMono-Regular.ttf"

TITLE_FILE="$CFG_FOLDER/title.txt"
TITLE_VIDEO="$OUTPUT_FOLDER/title.mp4"

SPEAKER_FILE="$CFG_FOLDER/speaker.txt"
SPEAKER_VIDEO="$OUTPUT_FOLDER/speaker.mp4"

SPONSORS_FILE="$CFG_FOLDER/sponsors.txt"
SPONSORS_VIDEO="$OUTPUT_FOLDER/sponsors.mp4"

CONCAT_FILE="$CFG_FOLDER/concat.txt"

DUMMY_FILE="$CFG_FOLDER/dummy.txt"

TALK_VIDEO="$OUTPUT_FOLDER/dummy.mp4"


# Title
ffmpeg -f lavfi -r 30 -i color=black:1920x1080 -f lavfi -i anullsrc -vf "drawtext="fontfile="$FONT_FILE":fontcolor=FFFFFF:fontsize=50:textfile="$TITLE_FILE":x=\(main_w-text_w\)/2:y=\(main_h-text_h\)/2",fade=t=in:st=0:d=1,fade=t=out:st=4:d=1" -c:v libx264 -b:v 1000k -pix_fmt yuv420p -video_track_timescale 15360 -c:a aac -ar 48000 -ac 2 -sample_fmt fltp -t 6 "$TITLE_VIDEO"

# Speaker
ffmpeg -f lavfi -r 30 -i color=black:1920x1080 -f lavfi -i anullsrc -vf "drawtext="fontfile="$FONT_FILE":fontcolor=FFFFFF:fontsize=50:textfile="$SPEAKER_FILE":x=\(main_w-text_w\)/2:y=\(main_h-text_h\)/2",fade=t=in:st=0:d=1,fade=t=out:st=4:d=1" -c:v libx264 -b:v 1000k -pix_fmt yuv420p -video_track_timescale 15360 -c:a aac -ar 48000 -ac 2 -sample_fmt fltp -t 6 "$SPEAKER_VIDEO"

# Sponsors
ffmpeg -f concat -safe 0 -i "$SPONSORS_FILE" -f lavfi -r 30 -i color=black:1920x1080 -c:v libx264 -pix_fmt yuv420p -vf fps=30 "$SPONSORS_VIDEO"

# Generate dummy video for testing purposes
ffmpeg -f lavfi -r 30 -i color=black:1920x1080 -f lavfi -i anullsrc -vf "drawtext="fontfile="$FONT_FILE":fontcolor=FFFFFF:fontsize=50:textfile="$DUMMY_FILE":x=\(main_w-text_w\)/2:y=\(main_h-text_h\)/2",fade=t=in:st=0:d=1,fade=t=out:st=4:d=1" -c:v libx264 -b:v 1000k -pix_fmt yuv420p -video_track_timescale 15360 -c:a aac -ar 48000 -ac 2 -sample_fmt fltp -t 6 "$TALK_VIDEO"

# Concat all and remove
ffmpeg -f concat -safe 0 -i $CONCAT_FILE -c copy "$OUTPUT_FOLDER/final.mp4"
rm {$TITLE_VIDEO,$SPEAKER_VIDEO,$SPONSORS_VIDEO,$TALK_VIDEO}
