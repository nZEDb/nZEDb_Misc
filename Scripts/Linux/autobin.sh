#!/bin/bash
<<DESCRIPTION
Linux script for automatically updating mediainfo / ffmpeg / unrar
By default, this will download unrar / ffmpeg pre-compiled, put them in your ~/bin/ folder, then it will compile
mediainfo and put it in the ~/bin/ folder. The next time you run, it will check if there are new versions to download,
and update them if needed.
DESCRIPTION

<<USAGE
Download the script to your home folder, or anywhere you want.
Download it like this: cd ~/ && wget https://raw.githubusercontent.com/nZEDb/nZEDb_Misc/master/Scripts/Linux/autobin.sh
Configure the settings below.
Make the script executable: chmod u+x ~/autobin.sh
Manually run at least once to make sure you have all the pre-requisite software.
To run the script: cd ~/ && ./autobin.sh
You can then make the script run every day with cron.
To make this script run every day at midnight (add with crontab -e -u YourUserName):
00 00 * * * bash /home/YourUserName/autobin.sh
USAGE

<<LICENSE
Copyright (C) 2015  kevinlekiller

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html
LICENSE

########################################################################################################################
############################################### Settings start #########################################################
########################################################################################################################

### General options:

# Set to x64 if you're on a 64bit O/S, x86 for a 32bit O/S.
ARCH="x64"

# Path to the which program. In case it is not in your PATH.
WHICH="/usr/bin/which"

# Path where to install the binaries (programs).
# Note if you set a path like /usr/local/bin you need to run this script with root permissions.
# If you use $HOME like the default, add this folder to your PATH by editing your ~/.profile file,
# something like this: PATH="$HOME/bin:$PATH"
# Note you might have to reboot if you add a folder to the PATH.
INSTALL_PATH="$HOME/bin"

# Path to download temp files. Note, contents will be deleted at the end of the script.
TMP_PATH="/tmp/autobin"

# Path to store subfolders below. By default this is hidden in your home folder.
MAIN_PATH="$HOME/.autobin"

# Path to keep track of software versions.
VERSIONS_PATH="$MAIN_PATH/versions"

# Path to store VCS (git/svn/etc) source files. Currently unused - might be used in the future.
VCS_PATH="$MAIN_PATH/vcs"

### Programs to install/update:

# Pre-compiled static builds from here: http://johnvansickle.com/ffmpeg/ - Installs ffmpeg / ffprobe
_FFMPEG=true

# Built from source. https://mediaarea.net/en/MediaInfo/Download/Source
_MEDIAINFO=true

# Pre-compiled: http://www.rarlab.com/download.htm
_UNRAR=true

########################################################################################################################
################################################ Settings end ##########################################################
########################################################################################################################

SCRIPT_START=$(date +%s)
echo "Notice: $0 started at" $(date)

if [[ ! -f "$WHICH" ]]; then
	echo "ERROR: $WHICH is missing!"
	exit 1
fi

checkBinary() {
	if [[ $("$WHICH" "$1") == "" ]]; then
		echo "ERROR: $1 is missing!"
		exit 2
	fi
}

checkBinary "cat"
checkBinary "curl"
checkBinary "grep"
checkBinary "head"
checkBinary "tar"

initTmpDir() {
	echo "Notice: Checking for new $1 version."
	rm -rf "$TMP_PATH/$1" && mkdir "$TMP_PATH/$1" && cd "$TMP_PATH/$1"
	curl -sL "$2" > "$1.html"
}

mkdir -p "$MAIN_PATH"
if [[ ! -d "$MAIN_PATH" ]]; then
	echo "ERROR: Unable to create main folder: $MAIN_PATH"
	exit 3
elif [[ ! -r "$MAIN_PATH" ]]; then
	echo "ERROR: Read permissions required on: $MAIN_PATH"
	exit 4
elif [[ ! -w "$MAIN_PATH" ]]; then
	echo "ERROR: Write permissions required on: $MAIN_PATH"
	exit 5
fi

mkdir -p "$VERSIONS_PATH"
mkdir -p "$VCS_PATH"
mkdir -p "$INSTALL_PATH"

mkdir -p "$TMP_PATH"
if [[ ! -d "$TMP_PATH" ]]; then
	echo "ERROR: Unable to create folder: $TMP_PATH"
	exit 6
fi

if [[ "$_UNRAR" == true ]]; then
	initTmpDir "unrar" "http://www.rarlab.com/download.htm"
	if [[ ! -f "unrar.html" ]]; then
		echo "Warning: Could not get latest unrar version number, skipping."
	else
		if [[ -f "$VERSIONS_PATH/unrar.txt" ]]; then
			LOCAL_VERSION=$(head "$VERSIONS_PATH/unrar.txt" | grep -Po '\d+\.\d+')
		fi
		REMOTE_VERSION=$(cat "unrar.html" | grep -Poi '\d+\.\d+\s*for\s*Linux' -m 1 | awk '{print $1;}')
		if [[ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]]; then
			URL_STRING=""
			if [[ "$ARCH" == "x64" ]]; then
				URL_STRING=$(cat "unrar.html" | grep -Poi '/rar/rarlinux-x64-[\d.]+\.tar.gz')
			else
				URL_STRING=$(cat "unrar.html" | grep -Poi '/rar/rarlinux-[\d.]+\.tar.gz')
			fi
			curl -sL "http://www.rarlab.com$URL_STRING" > "unrar.tar.gz"
			if [[ -f "unrar.tar.gz" ]]; then
				mkdir -p unrar && tar -xzf unrar.tar.gz -C "unrar/" --strip-components 1 && cd "unrar/"
				rm -rf "$INSTALL_PATH/unrar" && mv unrar "$INSTALL_PATH/unrar"
				echo "$REMOTE_VERSION" > "$VERSIONS_PATH/unrar.txt"
				echo "Notice: unrar updated to version $REMOTE_VERSION"
			else
				echo "Warning: Could not download latest unrar, skipping."
			fi
		else
			echo "Notice: unrar not updated because there is no newer version available."
		fi
	fi
fi

if [[ "$_FFMPEG" == true ]]; then
	initTmpDir "ffmpeg" "http://johnvansickle.com/ffmpeg/"
	if [[ ! -f "ffmpeg.html" ]]; then
		echo "Warning: Could not get latest version number of ffmpeg, skipping."
	else
		if [[ -f "$VERSIONS_PATH/ffmpeg.txt" ]]; then
			LOCAL_VERSION=$(head "$VERSIONS_PATH/ffmpeg.txt" | grep -Po '^[A-Za-z0-9]+$')
		fi
		REMOTE_VERSION=$(cat "ffmpeg.html" | grep -Po 'git:\s*[A-Za-z0-9]+' | awk '{print $2;}')
		if [[ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]]; then
			URL_STRING="http://johnvansickle.com/ffmpeg/builds/ffmpeg-git-32bit-static.tar.xz"
			if [[ "$ARCH" == "x64" ]]; then
				URL_STRING="http://johnvansickle.com/ffmpeg/builds/ffmpeg-git-64bit-static.tar.xz"
			fi
			curl -sL "$URL_STRING" > "ffmpeg.tar.xz"
			if [[ -f "ffmpeg.tar.xz" ]]; then
				mkdir -p ffmpeg && tar -xf ffmpeg.tar.xz -C "ffmpeg/" --strip-components 1 && cd "ffmpeg/"
				rm -rf "$INSTALL_PATH/ffmpeg" && mv ffmpeg "$INSTALL_PATH/ffmpeg"
				rm -rf "$INSTALL_PATH/ffprobe" && mv ffprobe "$INSTALL_PATH/ffprobe"
				echo "$REMOTE_VERSION" > "$VERSIONS_PATH/ffmpeg.txt"
				echo "Notice: ffmpeg updated to version $REMOTE_VERSION"
			else
				echo "Warning: Could not download latest ffmpeg, skipping."
			fi
		else
			echo "Notice: ffmpeg not updated because there is no newer version available."
		fi
	fi
fi

if [[ "$_MEDIAINFO" == true ]]; then
	checkBinary "autoconf"
	checkBinary "automake"
	checkBinary "g++"
	checkBinary "gcc"
	checkBinary "make"
	initTmpDir "mediainfo" "https://mediaarea.net/en/MediaInfo/Download/Source"
	if [[ ! -f "mediainfo.html" ]]; then
		echo "Warning: Could not get latest version number of mediainfo, skipping."
	else
		if [[ -f "$VERSIONS_PATH/mediainfo.txt" ]]; then
			LOCAL_VERSION=$(head "$VERSIONS_PATH/mediainfo.txt" | grep -Poi '^CLI_[\d.]+$')
		fi
		REMOTE_VERSION=$(cat "mediainfo.html" | grep -m 1 -Poi 'CLI_\d[\d.]+\d')
		if [[ "$REMOTE_VERSION" != "$LOCAL_VERSION" ]]; then
			curl -sL "https:$(cat "mediainfo.html" | grep -m 1 -Poi '//mediaarea.net/download/binary/mediainfo/[^<>]+?Source\.tar\.bz2')" > mediainfo.tar.bz2
			if [[ -f  "mediainfo.tar.bz2" ]]; then
				mkdir -p mediainfo && tar -xvjf mediainfo.tar.bz2 -C "mediainfo/" --strip-components 1 && cd "mediainfo/"
				sh CLI_Compile.sh
				cd "MediaInfo/Project/GNU/CLI"
				rm -rf "$INSTALL_PATH/mediainfo" && sudmv mediainfo "$INSTALL_PATH/mediainfo"
				echo "$REMOTE_VERSION" > "$VERSIONS_PATH/mediainfo.txt"
				echo "" && echo "Notice: mediainfo updated to version $REMOTE_VERSION"
			else
				echo "Warning: Could not download latest mediainfo, skipping."
			fi
		else
			echo "Notice: mediainfo not updated because there is no newer version available."
		fi
	fi
fi

echo "Notice: Clearing $TMP_PATH"
rm -rf "$TMP_PATH"
echo "Notice: $0 finished at" $(date) "in" $(($(date +%s) - SCRIPT_START)) "second(s)."
