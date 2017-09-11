#!/bin/bash
#
# Nearby plugin
#
source `dirname $0`/botija.init.sh


#
# install logic
function install {
    sudo apt-get -y install arp-scan && sudo chmod u+s /usr/bin/arp-scan  
    sudo apt-get -y install bluez bluez-hcidump && sudo setcap cap_net_raw+ep /usr/bin/hcitool 
    $local_dir/botija.sh send_text "$bl_nearby_install ($?)"
}


#
# scan logic
function scan {
    [ -z "$nearby_wifi_mac" ] &&  -z "$nearby_blue_mac" ] && echo "${bl_missing_config}: nearby_wifi_mac/nearby_blue_mac" && return 1
    mv $tmp_dir/scan.found.out $tmp_dir/scan.prev.out 2>/dev/null

    > $tmp_dir/scan.found.out
    for mac in `echo $nearby_blue_mac`; do
        hcitool cc "$mac" 2>/dev/null && hcitool rssi "$mac" 2>/dev/null && echo "$mac" >> $tmp_dir/scan.found.out
    done
    for mac in `arp-scan --localnet | grep "192.168" | awk '{print tolower($2)}'`; do
        [ "`echo $nearby_wifi_mac | grep -w $mac | wc -l`" -gt "0" ] && echo $mac >> $tmp_dir/scan.found.out
    done 
    cat $tmp_dir/scan.found.out | awk '{print "[nearby] " tolower($0)}'

    if [ "`diff $tmp_dir/scan.found.out $tmp_dir/scan.prev.out 2>/dev/null | wc -l`" -gt "0" ]; then
        found=`cat $tmp_dir/scan.found.out | wc -l`

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
