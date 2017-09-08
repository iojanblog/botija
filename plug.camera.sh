#!/bin/bash
#
# Camera plugin
#
source `dirname $0`/botija.init.sh


#
# install logic
function install {
    sudo apt-get install motion libav-tools
    echo "start_motion_daemon=yes" | sudo tee -a /etc/default/motion 
    echo "
        width 1024 
        height 768 
        event_gap 10
        webcontrol_port 9999 
        on_movie_end `cd $local_dir && pwd`/plugcallback.camera.sh video %f 
        on_picture_save `cd $local_dir && pwd`/plugcallback.camera.sh photo %f " | sudo tee -a /etc/motion/motion.conf
    sudo service motion start    
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