#!/bin/bash -
#title           : DSE Setup Script
#name            : setup.sh
#description     : This script will install DSE on the host
#author          : Ankit Tharwani (meetlytix.com)
#version         : 0.1
#==========================================================

# Init variables
java_version=101
base_dir=/Users/ankittharwani/Work/MIDS/Term4/W251/Assignment/Project/meetlytix/backend
log_file=dse_setup.log

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
INFO "Starting DSE setup on host: "`hostname`
#==========================================================

# Get DSE installation files

#==========================================================

# Install dependencies

install_jdk () {
  # download JDK from a source
  jdk_file=$base_dir/installations/jdk-8u$java_version-linux-x64.rpm
  rpm -ivh $jdk_file

  alternatives --install /usr/bin/java java /usr/java/jdk1.8.0_$java_version/bin/java 200000
  alternatives --config java

  echo "export JAVA_HOME=/usr/java/latest" >> ~/.bash_profile
  echo "export PATH=$JAVA_HOME/bin:$PATH" >> ~/.bash_profile
}

java_version_installed=`echo "$(java -version 2>&1)"`
if [ $? -ne 0 ]; then
  INFO "Java not available. Will proceed with Java installation now..."
  #install_jdk
else
  INFO "Java already installed. Current version:\n$java_version_installed"
fi

#==========================================================

# Get DSE installation files

#==========================================================

# Get DSE installation files

#==========================================================
