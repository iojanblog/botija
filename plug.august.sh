#!/bin/bash
#
# Camera plugin
#
source `dirname $0`/botija.init.sh


#
# install logic
function install {
    curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
    sudo apt-get install nodejs && sudo chown -R $(whoami) /usr/{lib/node_modules,bin,share}

    npm install -g bluetooth-hci-socket augustctl
    echo "{ \"offlineKey\": \"${august_offlineKey}\", \"offlineKeyOffset\": 1 }" > /usr/lib/node_modules/augustctl/config.json
    sudo setcap cap_net_raw+eip $(readlink -f `which node`)

    augustctl lock   
    $local_dir/botija.sh send_text "$bl_august_install ($?)"
}


#
# lock logic
function lock {
    timeout --preserve-status $delay_timeout augustctl lock
    $local_dir/botija.sh send_text "$bl_door_lock ($?)"
}


#
# unlock logic
function unlock {
    timeout --preserve-status $delay_timeout augustctl unlock
    $local_dir/botija.sh send_text "$bl_door_unlock ($?)"
}


#
# dispatch commands
case "$1" in 
install)
   shift && install $@
   ;;
lock)
   shift && lock $@
   ;;   
unlock)
   shift && unlock $@
   ;;       
*)
   echo "$bl_usage: $0 <$bl_command>"
   echo "$bl_command_guide install, lock, unlock"
esac