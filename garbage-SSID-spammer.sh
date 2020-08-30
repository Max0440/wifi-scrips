#!/bin/bash
#set wifiadapter to monitor mode
airmon-ng check kill
airmon-ng start wlan0

#spam SSIDs
mdk4 wlan0mon b -a -m -s 500
