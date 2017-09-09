#!/bin/bash
#
# BOT init logic
#

#
# directories
local_dir=`dirname $0`
tmp_dir="$local_dir/tmp" && mkdir -p $tmp_dir

#
# load config
config_file="$local_dir/botija.cfg"
[[ -f "$config_file" ]] && source $config_file || file $config_file

#
# load language
language_file="$local_dir/lang.${language}.cfg"
[[ ! -f $language_file ]] && language_file="$local_dir/lang.en.cfg"
[[ -f "$language_file" ]] && source $language_file || file $language_file
