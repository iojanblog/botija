#!/bin/bash
#
# Camera callback plugin
#
source `dirname $0`/botija.init.sh

event_id="$1"
event_arg="$2"

if [ "$event_id" = "video" ]; then
    avconv -y -i $event_arg -c:v libx264 -c:a copy ${event_arg}.mp4
    [ "$?" -ne "0" ] && $local_dir/botija.sh send_text "$bl_failed_avconv" && exit 1

    $local_dir/botija.sh send_video ${event_arg}.mp4
    rm -f ${event_arg}.mp4 ${event_arg}
elif [ "$event_id" = "photo" ]; then
    $local_dir/botija.sh send_photo ${event_arg}
    rm -f ${event_arg}
else
    $local_dir/botija.sh send_text "$event_id $bl_event_unknown"
fi
