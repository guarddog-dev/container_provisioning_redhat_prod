#!/bin/bash

PROVISIONING="/etc/firstboot/container_provisioning/provisioning.bin"
DOWNLOAD_PROVISIONING="/etc/firstboot/provisioning/donwload_provisioning.bin"
VOLUME="/etc/guarddog"
device_name=$1
license_email=$2
license_key=$3
env=$4
DEBUG=$5
EXTERNAL_LOG=$6
version=$7
DEBUG_DEFAULT="True"


print_provisioning_values() {
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then
        echo "---------------------------------------------"
        echo " DEVICE NAME:"$device_name
        echo " EMAIL:"$license_email
        echo " LICENSE KEY:"$license_key
        echo " ENV:"$env
        echo " DEBUG:"$DEBUG
        echo "---------------------------------------------"
    fi
}

create_volume_folders() {
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then
        echo "---------------------------------------------"
        echo " Creating volume directories."
        echo "---------------------------------------------"
        echo $VOLUME/
        echo $VOLUME/opt  
        echo $VOLUME/logs 
        echo $VOLUME/keys 
        echo $VOLUME/config_files 
        echo $VOLUME/scripts  
        echo $VOLUME/licenses
    
    fi
        mkdir -p $VOLUME/
        mkdir -p $VOLUME/opt  
        mkdir -p $VOLUME/logs 
        mkdir -p $VOLUME/keys 
        mkdir -p $VOLUME/config_files 
        mkdir -p $VOLUME/scripts  
        mkdir -p $VOLUME/licenses
    
}

set_region() {
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then    
        echo "---------------------------------------------"
        echo " Region: $REGION"
        echo "---------------------------------------------"
        echo $REGION > /etc/guarddog/opt/region
    else
        echo $REGION > /etc/guarddog/opt/region > /dev/null 2>&1 &
    fi
}


set_redis() {
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then
        echo "---------------------------------------------"
        echo " Starting Redis-Server..."
        echo "---------------------------------------------"
        redis-server /etc/redis/redis.conf --dir /etc/guarddog  &
    else
        redis-server /etc/redis/redis.conf --dir /etc/guarddog  >  /dev/null 2>&1 &
    fi
        echo 'vm.overcommit_memory = 1' > /etc/sysctl.conf 
}

set_image_version() {
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then
        echo "---------------------------------------------"
        echo " Saving edge sensor image version: $SENSOR_VERSION"
        echo "---------------------------------------------"
    fi
        echo $SENSOR_VERSION > /etc/guarddog/version
}


set_environment() {
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then
        echo "---------------------------------------------"
        echo " Saving environment: $env"
        echo "---------------------------------------------"
    fi
        echo $env > /etc/guarddog/opt/env
}

set_system_Log() {
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then
        echo "---------------------------------------------"
        echo " Saving system log: $EXTERNAL_LOG"
        echo "---------------------------------------------"
    fi
        echo $EXTERNAL_LOG > /etc/guarddog/opt/external_log
}

set_region() {
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then
        echo "---------------------------------------------"
        echo " Saving region: $REGION"
        echo "---------------------------------------------"
    fi
        echo $REGION > /etc/guarddog/opt/region
    
}


update_provisioning_repo(){
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then
        echo "---------------------------------------------"
        echo " Downloading Provisioning binaries.."
        echo "---------------------------------------------"
    fi 
    sudo git pull

}

set_supervisord(){
    if [[ $DEBUG == $DEBUG_DEFAULT ]]; then
    echo "---------------------------------------------"
    echo " Running supervisord ..."
    echo "---------------------------------------------"
    fi
    sudo mkdir -p /var/run && \
    sudo chown root:root /var/run && \
    sudo chmod 755 /var/run
    sudo supervisord -c /etc/supervisord.conf > /dev/null 2>&1 &
}

################################
print_provisioning_values

if [ -z "$license_key" ]; then
        echo "No License"
    else
    update_provisioning_repo
    create_volume_folders
    set_image_version
    set_environment
    set_region
    set_system_Log
    set_supervisord
fi




