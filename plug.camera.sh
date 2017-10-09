#!/bin/bash
#
# Camera plugin
#
source `dirname $0`/botija.init.sh


#
# install logic
function install {
    sudo modprobe bcm2835-v4l2 && echo bcm2835-v4l2 | sudo tee -a /etc/modules
    sudo apt-get -y install motion libav-tools
    echo "start_motion_daemon=yes" | sudo tee -a /etc/default/motion 
    echo "
        rotate 180
        width 1280 
        height 768 
        event_gap 5
        lightswitch 50
        max_movie_time 60
        stream_localhost off
        webcontrol_port 9999 
        locate_motion_mode on
        output_pictures off
        on_movie_end `cd $local_dir && pwd`/plug.camera.callback.sh video %f 
        on_picture_save `cd $local_dir && pwd`/plug.camera.callback.sh photo %f " | sudo tee -a /etc/motion/motion.conf
    sudo service motion restart    
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
    $local_dir/botija.sh send_text "$bl_control_motion ($?)"
}


#
# start motion logic
function start_motion {
    curl -s -X GET "http://localhost:9999/0/detection/start"
    $local_dir/botija.sh send_text "$bl_control_motion ($?)"
}


#
# stream url logic
function stream_url {
    $local_dir/botija.sh send_text "http://`hostname -I | head -1`:8081/"
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
stream_url)
    shift && stream_url $@
    ;;         
*)
   echo "$bl_usage: $0 <$bl_command>"
   echo "$bl_command_guide photo, stop_motion, start_motion, stream_url, install"
esac