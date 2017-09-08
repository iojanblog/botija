#!/bin/bash
#
# Camera plugin
#
source `dirname $0`/botija.init.sh


#
# install logic
function install {
    sudo apt-get install motion libav-tools
    sudo echo "\
        width 1024
        height 768
        webcontrol_port 9999 \
        on_movie_end `dirname $0`/plugcallback.camera.sh motion %f \
        " >> /etc/motion/motion.conf
    result="$?" && $local_dir/botija.sh send_text "$bl_camera_install ($result)"
}


#
# photo logic
function photo {
    curl -s -X GET "http://localhost:9999/0/action/snapshot"
    [ "$?" -ne "0" ] && $local_dir/botija.sh send_text "$bl_failed_photo"
}


#
# video logic
function video {
    curl -s -X GET "http://localhost:9999/0/action/makemovie"
    [ "$?" -ne "0" ] && $local_dir/botija.sh send_text "$bl_failed_video"
}


#
# dispatch commands
case "$1" in 
install)
   shift && install $@
   ;;
photo)
   shift && photo $@
   ;;  
video)
   shift && video $@
   ;;  
*)
   echo "$bl_usage: $0 <$bl_command>"
   echo "$bl_command_guide install, photo, video"
esac