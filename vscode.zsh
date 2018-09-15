#!/usr/bin/env bash

# Defines
NAME="vscode"
REPO="https://github.com/microsoft/vscode.git"
REPOPATH="/usr/local/src/$NAME"
INSTALLPATH="/usr/src/$NAME"
BINPATH="/usr/bin/$NAME"

install() {
	sources;
	prebuild;
	build;
	postbuild;
}

sources() {
	info "SOURCES"

	if [ -d "$REPOPATH" ]; then
		progress "updating sources"
		(cd $REPOPATH && git pull)
	fi

	progress "pulling github repo"
	git clone $REPO $REPOPATH
}

prebuild() {
	info "PRE-BUILD"

	progress "installing node 8"
	nvm install 8

	progress "running yarn"
	(cd $REPOPATH && yarn)

	# TODO: add extension data to product.json
	# "extensionsGallery": {
	# 	"serviceUrl": "https://marketplace.visualstudio.com/_apis/public/gallery",
	# 	"cacheUrl": "https://vscode.blob.core.windows.net/gallery/index",
	# 	"itemUrl": "https://marketplace.visualstudio.com/items"
	# }
}

build() {
	info "BUILD"

	progress "running gulp"
	(cd $REPOPATH && ./node_modules/.bin/gulp vscode-linux-x64-min)
}

postbuild() {
	info "POST-BUILD"

	progress "moving to install dir"
	(cd $REPOPATH && mv ./../VSCode-linux-x64 $INSTALLPATH)

	progress "linking executable"
	(cd $REPOPATH && ln -s $INSTALLPATH/bin/code-oss $BINPATH)
}
