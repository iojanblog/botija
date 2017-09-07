#!/bin/bash
#
# BOT logic
#
local_dir=`dirname $0`
tmp_dir="$local_dir/tmp" && mkdir -p $tmp_dir

#
# load config
config_file="$local_dir/botija.cfg"
[[ -f "$config_file" ]] && source $config_file && echo "--> $config_file" 

#
# load language
language_file="$local_dir/lang.${language}.cfg"
[[ ! -f $language_file ]] && language_file="$local_dir/lang.en.cfg"
[[ -f "$language_file" ]] && source $language_file && echo "--> $language_file" 

#
# setup path
[ "$nodejs_bin_path" != "" ] && export PATH=${nodejs_bin_path}:$PATH
command -v node >/dev/null 2>&1 && echo "--> node `node --version`" 


#
# receive logic
function receive {
    offset=`cat $tmp_dir/offset.txt 2>/dev/null | tail -1 2>/dev/null`
    curl -s -X GET "https://api.telegram.org/bot$token/getUpdates?limit=1&allowed_updates=message&offset=$offset&timeout=$pull_timeout" > $tmp_dir/result.out
    [ "`cat $tmp_dir/result.out | jq '.ok'`" != "true" ] && return 1
    [ "`cat $tmp_dir/result.out | jq '.result | length'`" = "0" ] && return 2

    update_id=`cat $tmp_dir/result.out | jq '.result[].update_id'`
    first_name=`cat $tmp_dir/result.out | jq '.result[].message.from.first_name'`   
    chat_id=`cat $tmp_dir/result.out | jq '.result[].message.chat.id'`
    text=`cat $tmp_dir/result.out | jq '.result[].message.text'`
    echo "--> $chat_id,$first_name,$update_id,$text"

    [ "`echo $households | grep -w $chat_id | wc -l`" -eq "0" ] && echo "$bl_insecure_chat $chat_id" && return 3
    echo "$((update_id+1))" > $tmp_dir/offset.txt

    normal_text=`echo $text | awk '{print tolower($0)}' | sed 's/"//g'`
    if [ "$normal_text" = "$bc_status" ]; then
        send_text "$bl_message $text $bl_from $first_name"
        . $local_dir/plug.status.sh
    else
        curl -s -X GET "https://api.telegram.org/bot$token/sendMessage" --data-urlencode "chat_id=$chat_id" --data-urlencode "text=$bl_unknown $text" >/dev/null &
        return 11
    fi    
}


#
# send text logic
function send_text {
    arg_text="$@"
    for hh in $households; do
        curl -s -X GET "https://api.telegram.org/bot$token/sendMessage" --data-urlencode "chat_id=$hh" --data-urlencode "text=$arg_text" --data-urlencode "disable_notification=true" > $tmp_dir/result.out &
    done    
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
*)
   echo "$bl_usage: $0 <$bl_command>"
   echo "$bl_command_guide receive, send_text, setup"
esac
