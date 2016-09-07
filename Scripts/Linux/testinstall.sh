#!/bin/bash

<<GPLV3
    Script for running the https://github.com/nZEDb/nZEDb web installer from the command line.
    This was written with the intention of nzedb developpers using it to see if the installer
    works correctly, but can be used by end users to set up nzedb.
    Change the settings below.
    @TODO Display errors on command line.

    Copyright (C) 2016  kevinlekiller

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
GPLV3

############################################################################################################
########################################### Settings #######################################################
############################################################################################################

# nzedb path
NZEDBPATH="/var/www/nZEDb"

# Web hostname for nzedb site (http://$HOST/)
HOST="localhost"
# Set to https if the site is https only.
HTTP="http"
AGENT="Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/51.0.2704.79 Chrome/51.0.2704.79 Safari/537.36"

# mysql settings (step 2 of installer)

DBUSER="admin"
DBPASS="123"
DBHOST="127.0.0.1"
DBPORT="3306"
DBSOCKET="/var/run/mysqld/mysqld.sock"
DBNAME="nzedb"

# ssl settings (step 3 of installer)
SSLCAFILE=""
SSLCAPATH=""
SSLVERIFYPEER="0"
SSLVERIFYHOST="0"
SSLALLOWSELFSIGNED="1"

# nntp settings (step 4 of installer) 
# User and password can be left empty if you are just testing the installer.
NNTPSERVER="news.astraweb.com"
NNTPUSER=""
NNTPPASS=""
NNTPPORT="119"
NNTPSSL="0"
NNTPSOCKTIMEOUT="120"
NNTPSERVER2=""
NNTPUSER2=""
NNTPPASS2=""
NNTPPORT2=""
NNTPSSL2=""
NNTPSOCKTIMEOUT2="120"

# admin settings (step 6 of installer)
ADMINUSER="admin"
ADMINPASS="123"
ADMINFIRSTNAME=""
ADMINLASTNAME=""
ADMINEMAIL="email@example.com"


# file paths (step 7 of installer)
COVERPATH="$NZEDBPATH/resources/covers/"
NZBPATH="$NZEDBPATH/resources/nzb/"
TMPPATH="$NZEDBPATH/resources/tmp/unrar/"


############################################################################################################
############################################################################################################
############################################################################################################

if [[ -e $NZEDBPATH/www/install/install.lock ]]; then
	echo "ERROR: $NZEDBPATH/www/install/install.lock exists! Please remove the file before continuing."
	exit 1
fi

which curl 1> /dev/null

if [[ $? != 0 ]]; then
	echo "ERROR: curl is required."
	exit 1
fi

PAGE=$(curl --head -s -L --url "$HTTP://$HOST/install" 2> /dev/null)
if [[ ! $PAGE =~ "200 OK" ]]; then
	echo "ERROR: Problem connecting to '$HTTP://$HOST/install/'"
	exit 1
fi

COOKIE=$(echo "$PAGE" | grep -Po "PHPSESSID.+?$")
if [[ $COOKIE == "" ]]; then
	echo "Could not find cookie!"
	exit 1
fi

curlPage() {
if [[ -z $3 ]]; then
	PAGE=$(curl \
	--url "$HTTP://$HOST/install/$1" \
	-L -s \
	--cookie "$COOKIE" \
	--header "Host: $HOST" \
	--header "Connection: keep-alive" \
	--header "Upgrade-Insecure-Requests: 1" \
	--header "User-Agent: $AGENT" \
	--header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
	--header "Referer: $HTTP://$HOST/install/$2" \
	--header "Accept-Language: en-US,en;q=0.8"
	)
else
	PAGE=$(curl \
	--data "$3" \
	--url "$HTTP://$HOST/install/$1" \
	-L -s \
	--cookie "$COOKIE" \
	--header "Host: $HOST" \
	--header "Connection: keep-alive" \
	--header "Upgrade-Insecure-Requests: 1" \
	--header "User-Agent: $AGENT" \
	--header "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" \
	--header "Referer: $HTTP://$HOST/install/$2" \
	--header "Accept-Language: en-US,en;q=0.8" \
	--header "Content-Type:application/x-www-form-urlencoded"
	)
fi
}

checkPage() {
	if [[ ! $PAGE =~ "$1" ]]; then
		echo "$PAGE"
		echo "ERROR: Problem on $HTTP://$HOST/install/step$2.php"
		exit 1
	fi
	echo "Success: $HTTP://$HOST/install/step$2.php ; $1"
}

curlPage "step1.php?"
checkPage "No problems were found and you are ready to install." 1

curlPage "step2.php?" "step1.php?" "db_system=mysql&host=$DBHOST&sql_port=$DBPORT&sql_socket=$DBSOCKET&user=$DBUSER&pass=$DBPASS&db=$DBNAME"
checkPage "The database setup is correct, you may continue to the next step." 2

curlPage "step3.php?" "step2.php?" "cafile=$SSLCAFILE&capath=$SSLCAPATH&verifypeer=$SSLVERIFYPEER&verifyhost=$SSLVERIFYHOST&allowselfsigned=$SSLALLOWSELFSIGNED"
checkPage "The openssl setup looks correct, you may continue to the next step." 3

curlPage "step4.php?" "step3.php?" "server=$NNTPSERVER&user=$NNTPUSER&pass=$NNTPPASS&port=$NNTPPORT&socket_timeout=$NNTPSOCKTIMEOUT&servera=$NNTPSERVER2&usera=$NNTPUSER2&passa=$NNTPPASS2&porta=$NNTPPORT2&socket_timeouta=$NNTPSOCKTIMEOUT2"
checkPage "The news server setup is correct, you may continue to the next step." 4

curlPage "step5.php?" "step4.php?"
checkPage "The configuration file has been saved, you may continue to the next step." 5

curlPage "step6.php?" "step5.php?" "user=$ADMINUSER&fname=$ADMINFIRSTNAME&lname=$ADMINLASTNAME&pass=$ADMINPASS&email=$ADMINEMAIL"
checkPage "The admin user has been setup, you may continue to the next step." 6

curlPage "step7.php?" "step6.php?" "coverspath=$COVERPATH&nzbpath=$NZBPATH&tmpunrarpath=$TMPPATH"
checkPage "Install Complete!" 7

echo "Install finished succesfully. You can now head to $HTTP://$HOST/admin/"
