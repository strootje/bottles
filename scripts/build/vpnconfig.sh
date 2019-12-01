#!/usr/bin/env bash

# Imports
# -none-

# Variables
declare -A CONFIG=()
CONFIGFILE="./.vpnrc"
PROMPT=">_"
TMPDIR="./.tmp"
OUTPUTDIR="./dist"

DEFAULT_VPN_ZIP="https://www.blackvpn.com/download/4040/"
DEFAULT_STUNNEL_ZIP="https://www.blackvpn.com/download/3987/"
DEFAULT_SSH_PATH="10.0.0.70:/opt/docker/openvpn-client/privacy"

info() {
	printf "[...] %s\n" "$@"
}

fatal() {
	info "$@"
	exit 1
}

run_check_for_deps() {
	if ! [ -x "$(command -v wget)" ]; then
		fatal "Please install wget"
	fi

	if ! [ -x "$(command -v 7z)" ]; then
		fatal "Please install 7z"
	fi

	if ! [ -x "$(command -v sed)" ]; then
		fatal "Please install sed"
	fi
}

run_get_config() {
	if [ ! -f $CONFIGFILE ]; then
		echo -e
		info "Enter URL for VPN archive: (default: $DEFAULT_VPN_ZIP)"
		read -p "$PROMPT " VPN_ZIP
		echo "VPN_ZIP=\"${VPN_ZIP:-$DEFAULT_VPN_ZIP}\"" >> $CONFIGFILE

		echo -e
		info "Enter URL for Stunnel archive: (default: $DEFAULT_STUNNEL_ZIP)"
		read -p "$PROMPT " STUNNEL_ZIP
		echo "STUNNEL_ZIP=\"${STUNNEL_ZIP:-$DEFAULT_STUNNEL_ZIP}\"" >> $CONFIGFILE

		echo -e
		info "Enter SSH Path: (default: $DEFAULT_SSH_PATH)"
		read -p "$PROMPT " SSH_PATH
		echo "SSH_PATH=\"${SSH_PATH:-$DEFAULT_SSH_PATH}\"" >> $CONFIGFILE

		echo -e
		info "Enter VPN Username:"
		read -p "$PROMPT " VPN_USER
		echo "VPN_USER=\"$VPN_USER\"" >> $CONFIGFILE

		echo -e
		info "Enter VPN Password:"
		read -p "$PROMPT " VPN_PASS
		echo "VPN_PASS=\"$VPN_PASS\"" >> $CONFIGFILE
	fi

	IFS="="
	while read -r name value
	do
		CONFIG[${name}]=${value//\"/}
	done < $CONFIGFILE
}

run_download() {
	SOURCE=$2
	TARGET=$TMPDIR/$1

	mkdir -p $TMPDIR
	wget --quiet --show-progress --progress=bar --output-document=$TARGET $SOURCE

	echo $TARGET
}

run_extract() {
	ARCHIVE=$2
	EXTRACT_TO=$TMPDIR/$1

	mkdir -p $EXTRACT_TO
	7z x -o$EXTRACT_TO $ARCHIVE > /dev/null

	echo $EXTRACT_TO
}

run_vpn_transform() {
	SOURCE=$2
	TARGET=$OUTPUTDIR/$1
	mkdir -p $TARGET

	info "Copy files as they are"
	cp -r $SOURCE/* $TARGET

	info "Creating VPN auth file"
	echo "${CONFIG[VPN_USER]}" >> $TARGET/vpn.auth
	echo "${CONFIG[VPN_PASS]}" >> $TARGET/vpn.auth

	for file in $TARGET/*.conf; do
		info "Updating vpn file $file"

		sed -i "s/auth-user-pass/auth-user-pass vpn.auth/g" $file
		sed -i "s/sndbuf/#sndbuf/g" $file
		sed -i "s/rcvbuf/#rcvbuf/g" $file
		sed -i "s/tls-remote/#tls-remote/g" $file
		sed -i "s/ns-cert-type/remote-cert-tls/g" $file
		sed -i "s/up \/etc\/openvpn\/update-resolv-conf/up \/etc\/openvpn\/up.sh/g" $file
		sed -i "s/down \/etc\/openvpn\/update-resolv-conf/down \/etc\/openvpn\/down.sh/g" $file
		echo "redirect-gateway def1" >> $file
	done
}

run_stunnel_transform() {
	SOURCE=$2
	TARGET=$OUTPUTDIR/$1
	mkdir -p $TARGET

	info "Copy files as they are"
	cp -r $SOURCE/* $TARGET

	file=$TARGET/stunnel.conf
	info "Updating stunnel config"
	sed -i "s/chroot = \/var\/lib\/stunnel4\//chroot = \/var\/lib\/stunnel\//g" $file
	sed -i "s/options = NO_SSLv2/sslVersion = all/g" $file
	sed -i "s/options = NO_SSLv3/output = \/stunnel.log/g" $file
	sed -i "s/cert=client.pem/cert = \/etc\/stunnel\/client.pem/g" $file
}

run_source() {
	info "Sourcing.."
}

run_main() {
	run_check_for_deps
	run_get_config

	info "Download & Extract VPN archive"
	VPN_ZIP=$(run_download "vpn.zip" ${CONFIG[VPN_ZIP]})
	VPN_DIR=$(run_extract "vpn" $VPN_ZIP)
	run_vpn_transform "vpn" $VPN_DIR

	info "Download & Extract Stunnel archive"
	STUNNEL_ZIP=$(run_download "stunnel.zip" ${CONFIG[STUNNEL_ZIP]})
	STUNNEL_DIR=$(run_extract "stunnel" $STUNNEL_ZIP)
	run_stunnel_transform "stunnel" $STUNNEL_DIR
}

case "$1" in
	"build") run_main;;
	*) run_source;;
esac
