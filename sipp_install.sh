#!/bin/bash

# Originally Created By : Keith Croxford (https://www.linkedin.com/in/kcroxford/)
# Modified for CentOS-7 By: Hassaan Ali (www.linkedin.com/in/hassaana)
# Date: 5/27/2020 
# Purpose: This script will install SIPp on a fresh install of CentOS 7.
# Instructions : 
#   1. Copy the script to your home folder
#   2. Make the script executable on your system
#      sudo chmod +x sipp_install.sh 
#   3. From your home directory, run the script
#      sudo ./sipp_install.sh 
#   4. The script will install a number of dependencies and sipp.
#   5. The script will also create a symbolic link so that you can run
#      sipp anywhere within the cli. 
#   6. Finally, it will clone an amazing set of sample scenarios from 
#        https://github.com/saghul/sipp-scenarios
#

#fail on errors
set -eu -o pipefail 

sudo -n true
test $? -eq 0 || exit 1 "You need sudo privilleges to run this!"

echo !!! Performing a package update. !!! 

yum update

echo !!! Installing the pre-reqs for sipp3.3 !!!

while read -r p ; do sudo yum install -y $p ; done < <(cat << "EOF"
    openssl
    openssl-devel
    perl-Net-Pcap
    ncurses-devel
    libpcap-devel
    lksctp-tools-devel
    autoconf 
    make
    gcc
    git 
    bison  
EOF
)
yum --setopt=group_package_types=mandatory,default,optional groupinstall "Development Tools" -y

echo !!! Obtaining sipp source file. !!!
sudo wget https://downloads.sourceforge.net/project/sipp/sipp/3.3/sipp-3.3.tar.gz -P /tmp

echo !!! Untarring to /opt/sipp3-3 !!!
tar -xzvf /tmp/sipp-3.3.tar.gz --directory /opt

echo !!! Changing directories !!!
cd /opt/sipp-3.3

echo !!! Running make !!! 
autoreconf -ivf; ./configure --with-pcap --with-sctp; make

echo !!! SIPp is now installed, creating symbolic link !!! 
sudo ln -s /opt/sipp-3.3/sipp /usr/local/bin/sipp 

echo !!! Cloning the sample repo !!!
git clone https://github.com/saghul/sipp-scenarios

echo !!! You can now run SIPp by typing "sudo sipp" anywhere within the CLI. !!! 

