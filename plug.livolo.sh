#!/bin/bash
#
# Livolo plugin
#
source `dirname $0`/botija.init.sh


#
# install logic
function install {
    sudo apt-get -y install python-rpi.gpio && python $local_dir/plug.livolo.py off
    $local_dir/botija.sh send_text "$bl_livolo_install ($?)"
}


#
# toggle logic
function toggle {
    python $local_dir/plug.livolo.py "b${1}"
    $local_dir/botija.sh send_text "$bl_livolo_toggle ($?)"
}


#
# off logic
function off {
    python $local_dir/plug.livolo.py off
    $local_dir/botija.sh send_text "$bl_livolo_off ($?)"
}


#
# dispatch commands
case "$1" in 
install)
    shift && install $@
    ;;
toggle)
    shift && toggle $@
    ;;
off)
    shift && off $@
    ;;
*)
   echo "$bl_usage: $0 <$bl_command>"
   echo "$bl_command_guide toggle <index>, off, install"
esac
