#!/bin/bash
#
# Camera plugin
#
source `dirname $0`/botija.init.sh
export PATH=$(realpath $tmp_dir)/nodejs/bin:$PATH


#
# install logic
function install {
    [ -z "$1" ] && echo "${bl_missing_argument}: offlineKey" && return 1
    command -v node || install_nodejs

    npm install -g bluetooth-hci-socket augustctl
    sudo setcap cap_net_raw+eip $(readlink -f `which node`)
    echo "{ \"offlineKey\": \"${1}\", \"offlineKeyOffset\": 1 }" > $(npm config get prefix)/lib/node_modules/augustctl/config.json

    timeout --preserve-status 5 augustctl lock   
    $local_dir/botija.sh send_text "$bl_august_install ($?)"
}


function install_nodejs {
    curl -SL https://nodejs.org/dist/v7.8.0/node-v7.8.0-linux-armv7l.tar.xz | tar xJv
    mv node-v7.8.0-linux-armv7l $tmp_dir/nodejs
    echo "[installed local] $tmp_dir/nodejs/bin"
}


#
# lock logic
function lock {
    timeout --preserve-status 5 augustctl lock
    $local_dir/botija.sh send_text "$bl_door_lock ($?)"
}


#
# unlock logic
function unlock {
    timeout --preserve-status 5 augustctl unlock
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
   echo "$bl_command_guide lock, unlock, install <offlineKey>"
esac