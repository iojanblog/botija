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
        width 1280 
        height 768 
        event_gap 5
        webcontrol_port 9999 
        locate_motion_mode on
        output_pictures off
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
# stop motion logic
function stop_motion {
    curl -s -X GET "http://localhost:9999/0/detection/pause"
    [ "$?" -ne "0" ] && $local_dir/botija.sh send_text "$bl_failed_motion"
}


#
# start motion logic
function start_motion {
    curl -s -X GET "http://localhost:9999/0/detection/start"
    [ "$?" -ne "0" ] && $local_dir/botija.sh send_text "$bl_failed_motion"
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
stop_motion)
   shift && stop_motion $@
   ;;   
start_motion)
   shift && start_motion $@
   ;;       
*)
   echo "$bl_usage: $0 <$bl_command>"
   echo "$bl_command_guide install, photo, video, stop_motion, start_motion"
esac