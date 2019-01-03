#!/usr/bin/env fish

set ARCH win64
set PREFIX /opt/cellar/world-of-warcraft/
set SOURCEDIR "/run/media/UserData/games/World of Warcraft 1.12.1"
set INSTALLDIR "$PREFIX/drive_c/Program Files/World of Warcraft"
set VARS WINEARCH=$ARCH WINEPREFIX=$PREFIX

if not test -d $PREFIX;
	mkdir -p $PREFIX
	eval env $VARS winecfg
end

if not test -d $INSTALLDIR;
	ln -ds $SOURCEDIR $INSTALLDIR
end

eval env $VARS wine start /unix '$INSTALLDIR/WoW.exe'
