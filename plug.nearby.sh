#!/bin/bash
#
# Nearby plugin
#
source `dirname $0`/botija.init.sh


#
# install logic
function install {
    sudo apt-get -y install arp-scan && sudo chmod u+s /usr/bin/arp-scan   
    $local_dir/botija.sh send_text "$bl_nearby_install ($?)"
}


#
# scan logic
function scan {
    [ -z "$nearby_wify_mac" ] && echo "${bl_missing_config}: nearby_wify_mac" && return 2
    mv $tmp_dir/scan.found.out $tmp_dir/scan.prev.out 2>/dev/null

    > $tmp_dir/scan.found.out
    for mac in `arp-scan --localnet | grep "192.168" | awk '{print $2}'`; do
        [ "`echo $nearby_wify_mac | grep -w $mac | wc -l`" -gt "0" ] && echo $mac >> $tmp_dir/scan.found.out
    done 

    if [ "`diff $tmp_dir/scan.found.out $tmp_dir/scan.prev.out 2>/dev/null | wc -l`" -gt "0" ]; then
        found=`cat $tmp_dir/scan.found.out | wc -l`
        $local_dir/botija.sh send_text "$bl_nearby_found $found"

        [ "$nearby_empty_lock" = "true" ] && [ "$found" = "0" ] && $local_dir/plug.august.sh lock
        [ "$nearby_empty_motion" = "true" ] && [ "$found" = "0" ] && $local_dir/plug.camera.sh start_motion
    fi
}


#
# dispatch commands
case "$1" in 
install)
   shift && install $@
   ;;
scan)
   shift && scan $@
   ;;        
*)
   echo "$bl_usage: $0 <$bl_command>"
   echo "$bl_command_guide scan, install"
esac
