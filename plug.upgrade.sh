#!/bin/bash
#
# Status plugin
#
source `dirname $0`/botija.init.sh

`cd $local_dir && git pull`
$local_dir/botija.sh send_text "$bl_upgrade_finished ($?)"