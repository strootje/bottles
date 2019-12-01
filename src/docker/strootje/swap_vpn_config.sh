#!/usr/bin/env bash

# Imports
# -none-

# Variables
VPNDIR=/vpn
VPNFILE=$VPNDIR/vpn.conf

info() {
	printf "[ ] %s\n" "$@"
}

rm -f $VPNFILE
files=($VPNDIR/Privacy-*.conf)
NEWFILE="${files[RANDOM % ${#files[@]}]}"
info "Swapping to '$NEWFILE'"
cp $NEWFILE $VPNFILE
