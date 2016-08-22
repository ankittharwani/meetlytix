#!/bin/bash -
#title           : DSE Host Provision
#name            : setup_host.sh
#description     : This script will install DSE on the host
#author          : Ankit Tharwani (meetlytix.com)
#version         : 0.1
#==========================================================

base_dir="/Users/ankittharwani/Work/MIDS/Term4/W251/Assignment/Project/meetlytix/backend"
log_file="dse_host_setup.log"

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

ram="16384"
cpu="8"
os="REDHAT_LATEST_64"
domain="meetlytix.com"
disk="100"
network="1000"
key="ankitmacpersonal"
next_host=""
new_host_ip=""

meetlytix_dc_names=(meetlytix-dc-01 meetlytix-dc-02)
meetlytix_dc_id=(c5c7c2d2-cc2b-4320-a715-b77ae4043e01 870bc447-8d44-40fe-a656-6f5bad71ee79)
sl_dc_id=(sjc03 dal05)
session_id=""
session_header=""
datacenter=$1

#==========================================================

get_host_details () {
  last_host=`slcli vs list | grep datastax | cut -d ' ' -f 3 | tail -1`
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
  --key $key
  slcli vs ready '$next_host' --wait=600
  INFO "Host is now ready: "$next_host

}

get_new_host_details() {
  new_host_ip=`slcli vs list | grep $next_host | cut -d ' ' -f 7`
  #new_host_ip=`slcli vs list | grep $last_host | cut -d ' ' -f 7`
  INFO "New host IP: "$new_host_ip
  ssh -o "StrictHostKeyChecking no" root@$new_host_ip "yum -y install git"
  scp ../../../../id* root@$new_host_ip:~/.ssh/
  scp ../../../../authorized_keys root@$new_host_ip:~/.ssh/
}

update_dns() {
  slcli dns record-add meetlytix.com $next_host A $new_host_ip
}

login_dse_lcm() {
  session_id=`curl -X POST -d '{"username":"admin","password":"M33tlytix123"}' 'http://datastax-01.meetlytix.com:8888/login' | jq '.sessionid' | tr -d '"'`
  session_header=`printf "'opscenter-session: %s'" "$session_id"`
}

add_host_dse_dc() {

}

INFO "Getting new host requirements..."
get_host_details

INFO "Requesting new host..."
request_new_host

INFO "Getting new host details..."
get_new_host_details
