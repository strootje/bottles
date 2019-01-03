#!/usr/bin/env fish

set ARCH win64
set PREFIX /opt/cellar/gog-galaxy
set DOWNLOADPATH https://cdn.gog.com/open/galaxy/client/setup_galaxy_1.2.51.30.exe
set INSTALLER "$HOME/Downloads/galaxy-setup.exe"
set INSTALLDIR "$PREFIX/drive_c/Program Files (x86)/GOG Galaxy"
set DATADIR "$PREFIX/drive_c/ProgramData/GOG.com/Galaxy"
set VARS WINEARCH=$ARCH WINEPREFIX=$PREFIX

if not test -d $PREFIX;
	echo "Building prefix"
	mkdir -p $PREFIX
	eval env $VARS winetricks -q win8 dotnet45 corefonts
end

if not test -f $INSTALLER;
	echo "Downloading installer"
	wget -v -O $INSTALLER $DOWNLOADPATH
end

if not test -d $INSTALLDIR;
	echo "Installing galaxy"
	eval env $VARS wine start /unix '$INSTALLER'
end

echo "Running galaxy"
eval env $VARS winecfg
# eval env $VARS winetricks -q win8
# eval env $VARS wine start /unix '$DATADIR/redists/GalaxyCommunication.exe' &
# eval env $VARS wine start /unix '$INSTALLDIR/GalaxyClient.exe /runWithoutUpdating'
eval env $VARS wine start /unix '$INSTALLDIR/Games/The\ Marvellous\ Miss\ Take/misstake.exe'
