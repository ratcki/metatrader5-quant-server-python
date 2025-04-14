#!/bin/bash

source /scripts/02-common.sh

log_message "RUNNING" "04-install-mt4.sh"

# Check if MetaTrader 5 is installed
if [ -e "$mt4file" ]; then
    log_message "INFO" "File $mt4file already exists."
else
    log_message "INFO" "File $mt4file is not installed. Installing..."

    # Set Windows 10 mode in Wine and download and install mt4
    $wine_executable reg add "HKEY_CURRENT_USER\\Software\\Wine" /v Version /t REG_SZ /d "win10" /f
    log_message "INFO" "Downloading mt4 installer..."
    wget -O /tmp/mt4setup.exe $mt4setup_url > /dev/null 2>&1
    log_message "INFO" "Installing MetaTrader 5..."
    $wine_executable /tmp/mt4setup.exe /auto
    rm -f /tmp/mt4setup.exe
fi

# Recheck if MetaTrader 5 is installed
if [ -e "$mt4file" ]; then
    log_message "INFO" "File $mt4file is installed. Running mt4..."
    $wine_executable "$mt4file" &
else
    log_message "ERROR" "File $mt4file is not installed. mt4 cannot be run."
fi