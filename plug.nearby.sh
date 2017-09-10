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
    for mac in `arp-scan --localnet | grep "192.168" | awk '{print $2}'`; do
        [ "`echo $nearby_wify_mac | grep -w $mac | wc -l`" -gt "0" ] && echo $mac >> $tmp_dir/scan.found.out
    done 

    if [ "`diff $tmp_dir/scan.found.out $tmp_dir/scan.prev.out | wc -l`" -gt "0" ]; then
        found=`wc -l $tmp_dir/scan.found.out`
        $local_dir/botija.sh send_text "$bl_nearby_found $found"
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
