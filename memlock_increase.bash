#!/bin/bash
# memlock script
# This script is designed to determine the amount of memory on the system and raise memlock accordingly.
# Author: Christopher Morton
# Email: chris.morton@rackspace.com
# Date: 05/27/2022
# Version: .1

# Global variables
# Color and formatting
RESET='\033[0m'
YELLOW='\033[33m'
ORANGE='\033[38;5;209m'
LCYAN='\033[96m'

echo -e "${LCYAN}Info${RESET}: Adding these two lines to your ${ORANGE}/etc/secuirty/limits.conf${RESET} will increase your memory lock to 80% of the system available memory.\n${YELLOW}WARNING${RESET}: Reboot is required for changes to take affect."
awk '/MemTotal/{total_mem=$2 ; memlock=total_mem*.8 ; print "root    soft memlock  "memlock"\nroot    hard memlock  "memlock;}' /proc/meminfo