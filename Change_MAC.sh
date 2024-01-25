#!/bin/bash
#Change mac address on macOS
#by morty1911
#01.2024

echo "$(tput setaf 4)Start script change MAC address on macOS"
#Restart wifi
echo "$(tput setaf 4)Disconnect WiFi"
sudo /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -z
while
#Generate new MAC
echo "$(tput setaf 4)Generate new MAC..."
do
    #Generate mac address
    while
        mac=$(openssl rand -hex 6)
    do
        #Attempt change MAC
        a=$(sudo ifconfig en0 ether $mac 2> /dev/null)
        #Chek fail
        if [ $? -eq 0 ]
        then
            echo "$(tput setaf 2)OK!"
            break
        else
            echo "$(tput setaf 1)FAIL! Restart generate..."
            continue
        fi
    done
    #Apply new MAC
    echo "$(tput setaf 4)Apply new MAC address..."
    sudo ifconfig en0 ether $mac
    #Display new MAC
    grep_ether=$(ifconfig en0 | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}')
    echo "$(tput setaf 4)New MAC: $grep_ether"
    #Restart Wi-Fi for autoconnect
    echo "$(tput setaf 4)Restart Wi-Fi..."
    networksetup -setairportpower en0 off
    sleep 1
    networksetup -setairportpower en0 on
    exit
done
