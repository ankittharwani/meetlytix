#!/bin/bash -
#title           : DSE Host Provision
#name            : setup_host.sh
#description     : This script will install DSE on the host
#author          : Ankit Tharwani (meetlytix.com)
#version         : 0.1
#==========================================================

base_dir=/Users/ankittharwani/Work/MIDS/Term4/W251/Assignment/Project/meetlytix/backend
log_file=dse_host_setup.log
datacenter=$1
ram=16384
cpu=8
os=REDHAT_LATEST_64
domain=meetlytix.com
disk=100
network=1000
key=ankitmacpersonal

echo $datacenter
# Init logger
source $base_dir/common/logger.sh
SCRIPTENTRY $base_dir/logs/$log_file

#==========================================================

# Print logo
logo="
                     _   _       _   _
 _ __ ___   ___  ___| |_| |_   _| |_(_)_  __
| '_ \` _ \ / _ \/ _ \ __| | | | | __| \ \/ /
| | | | | |  __/  __/ |_| | |_| | |_| |>  <
|_| |_| |_|\___|\___|\__|_|\__, |\__|_/_/\_\\
                           |___/

"
printf "%s\n" "$logo"
PRINT "\n$logo"

#==========================================================
get_host_details () {
  last_host=`slcli vs list | grep datastax | cut -d ' ' -f 3`
  INFO "Last DSE host deployed: "$last_host

  last_host_num=`echo $last_host | cut -d '-' -f 2`
  next_host_num=$((last_host_num + 1))
  next_host_num=`printf %02d $next_host_num`

  next_host="datastax-"$next_host_num
  INFO "New host created would be: "$next_host
}

request_new_host () {
  echo y | slcli vs create \
  --hostname $next_host \
  --domain $domain \
  --cpu $cpu \
  --memory $ram \
  --os $os \
  --datacenter $datacenter \
  --disk=$disk \
  --network $network \
  --key $key \
  --wait 60
  slcli vs ready '$next_host' --wait=600
}

INFO "Getting new host details..."
get_host_details

INFO "Requesting new host..."
request_new_host
