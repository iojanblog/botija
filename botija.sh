#!/bin/bash
#
# BOT logic
#
source `dirname $0`/botija.init.sh


#
# receive logic
function receive {
    offset=`cat $tmp_dir/offset.txt 2>/dev/null | tail -1 2>/dev/null`
    curl -s -X GET "https://api.telegram.org/bot$token/getUpdates?limit=1&allowed_updates=message&offset=$offset&timeout=$pull_timeout" > $tmp_dir/result.out

    echo "[receive] `cat $tmp_dir/result.out | jq .`"
    [ "`cat $tmp_dir/result.out | jq '.ok'`" != "true" ] && return 1
    [ "`cat $tmp_dir/result.out | jq '.result | length'`" = "0" ] && return 2

    update_id=`cat $tmp_dir/result.out | jq '.result[].update_id'`
    first_name=`cat $tmp_dir/result.out | jq '.result[].message.from.first_name'`   
    chat_id=`cat $tmp_dir/result.out | jq '.result[].message.chat.id'`
    text=`cat $tmp_dir/result.out | jq '.result[].message.text'`

    echo "$((update_id+1))" > $tmp_dir/offset.txt
    [ "`echo $households | grep -w $chat_id | wc -l`" -eq "0" ] && echo "$bl_insecure_chat $chat_id" && return 3

    send_text "$bl_message $text $bl_from $first_name"
    normal_text=`echo $text | awk '{print tolower($0)}' | sed 's/"//g'`

    if [ "$normal_text" = "$bc_status" ]; then
        $local_dir/plug.status.sh
    elif [ "$normal_text" = "$bc_photo" ]; then
        $local_dir/plug.camera.sh photo
    elif [ "$normal_text" = "$bc_video" ]; then
        $local_dir/plug.camera.sh video
    else
        curl -s -X GET "https://api.telegram.org/bot$token/sendMessage" --data-urlencode "chat_id=$chat_id" --data-urlencode "text=$bl_unknown $text" >/dev/null &
    fi    
}


#
# send text logic
function send_text {
    arg_text="$@"
    for hh in $households; do
        curl -s -X GET "https://api.telegram.org/bot$token/sendMessage" --data-urlencode "chat_id=$hh" --data-urlencode "text=$arg_text" --data-urlencode "disable_notification=true" >/dev/null &
    done    
    echo "[send_text] $arg_text"
    wait
}


#
# send video logic
function send_video {
    arg_video="$@"
    for hh in $households; do
        curl -s -X POST "https://api.telegram.org/bot$token/sendVideo" -F "chat_id=$hh" -F "video=@$arg_video" -F "disable_notification=true" &
    done    
    echo "[send_video] $arg_video"
    wait
}


#
# dispatch commands
case "$1" in 
receive)
   shift && receive $@
   ;;
send_text)
   shift && send_text $@
   ;;  
send_video)
   shift && send_video $@
   ;;     
*)
   echo "$bl_usage: $0 <$bl_command>"
   echo "$bl_command_guide receive, send_text, send_video"
esac
