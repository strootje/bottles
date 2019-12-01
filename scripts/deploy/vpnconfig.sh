#!/usr/bin/env bash

# Imports
source ./scripts/build/vpnconfig.sh

# Variables
declare -A CONFIG=()
CONFIGFILE="./.vpnrc"
PROMPT=">_"

run_check_for_deps
run_get_config

info "Deploying VPN files"
scp -r $OUTPUTDIR/vpn/* ${CONFIG[SSH_PATH]}/vpn

info "Deploying Stunnel files"
scp -r $OUTPUTDIR/stunnel/* ${CONFIG[SSH_PATH]}/stunnel
