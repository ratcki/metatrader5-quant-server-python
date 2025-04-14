#!/bin/bash
# Set variables
mt4setup_url="https://download.mql5.com/cdn/web/metaquotes.software.corp/mt4/mt4setup.exe"
mt4file="/config/.wine/drive_c/Program Files/MetaTrader/terminal64.exe"
wine_executable="wine"
# metatrader_version="5.0.36"
mt4server_port=18812

# Function to show messages
log_message() {
    local level=$1
    local message=$2
    echo "$(date '+%Y-%m-%d %H:%M:%S') - [$level] $message" >> /var/log/mt4_setup.log
}

# Mute Unnecessary Wine Errors
export WINEDEBUG=-all,err-toolbar,fixme-all