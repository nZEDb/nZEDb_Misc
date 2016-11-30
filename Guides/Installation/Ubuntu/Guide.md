Ubuntu Web Guide.
============
>This guide was designed for Ubuntu 12.04+ and derivatives (Linux Mint/Elemantary OS/etc.), using this guide on Debian or other Linux Distributions might or might not function. This guide might have errors or be obsolete by the time you read it, doing some research on your part on how to fix issues if they arise is required.

### Notes:
>In this guide you will see commands within grey rectangles, example:
`this is an example`
When you see these, you must type them into a command line interface (terminal window).

> PHP 5.6 and MySQL 5.5 are the minimum required versions,
but higher versions (MySQL 5.6 to be exact) are recommended. For 32 bit Operating Systems, PHP 5.6+ is required (to fix a bug in a required feature).

### Step 1 *Updating your operating system:*
>Update all your sources:
>>`sudo apt-get update`

---

>Upgrade your applications:
>>`sudo apt-get upgrade`

---

>**Optional:** Upgrade some other stuff (like the kernel).
>>`sudo apt-get dist-upgrade`

>You must now reboot your server.
>>`sudo reboot`

### Step 2 *Installing pre-requisite software:*
>These programs will be used later on to install additional software.
They might already be installed on your operating system.
>>`sudo apt-get install software-properties-common python-software-properties git`

### Step 3 *Adding a repository for the minimum supported PHP version:*
>nZEDb supports PHP version 5.6 or higher, if your distro does not have 5.6+, you must add a repository.

>To add PHP 5.6 or 7 which are the current supported versions of PHP:
>>`sudo add-apt-repository ppa:ondrej/php`

>>`sudo apt-get update`

### Step 4 *Installing PHP and the required extensions:*
> Note that some extensions might be missing here,
see INSTALL.txt in the nZEDb docs folder for all the required extensions.

> For PHP 5.6:
>>`sudo apt-get install php-pear php-imagick php5.6 php5.6-cli php5.6-dev php5.6-json php-pear php5.6-gd php5.6-mysql php5.6-pdo php5.6-curl php5.6-common php5.6-mcrypt php5.6-mbstring php5.6-xml`

> For PHP 7:
>>`sudo apt-get install php-pear php-imagick php7.0 php7.0-cli php7.0-dev php7.0-common php7.0-curl php7.0-json php7.0-gd php7.0-mysql php7.0-mbstring php7.0-mcrypt php7.0-xml`

### Step 5 **[Mandatory]** *Apparmor:*
>Apparmor restricts certain programs, on nZEDb it stops us from using the
MySQL LOAD DATA commands.
You can read more on Apparmor [here](http://en.wikipedia.org/wiki/AppArmor).

>*You have two options*:

---

>Option 1: Disabling Apparmor
>>`sudo apt-get purge apparmor`

>>`sudo update-rc.d apparmor disable`


---

>Option 2: Making Apparmor ignore MySQL
>>`sudo apt-get install apparmor-utils`

>>`sudo aa-complain /usr/sbin/mysqld`

>If this does not work, try [this tutorial](http://www.cyberciti.biz/faq/ubuntu-linux-howto-disable-apparmor-commands/).

---

>**You MUST reboot your server after doing this!**
>>`sudo reboot`

### Step 6 *Installing a MySQL server and client:*
>You have multiple choices when it comes to a MySQL server and client,
you will need to do some research to figure out which is the best for you.
We recommend MariaDB for most people.
Only install one of the following three to avoid issues.

>[MariaDB (we recommend this)](https://mariadb.com/kb/en/mariadb-versus-mysql-compatibility/):
>>`sudo apt-get install mariadb-server mariadb-client libmysqlclient-dev`

---

>[MySQL](http://dev.mysql.com/doc/refman/5.6/en/features.html):
>>`sudo apt-get install mysql-server mysql-client libmysqlclient-dev`

---

>[Percona](http://www.percona.com/software/percona-server/feature-comparison):

>Add the repo key:
>>`sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A`

>Create a text file to put in the repo source:
>>`sudo nano /etc/apt/sources.list.d/percona.list`

>Paste the deb and deb-src lines, replacing VERSION with the name of your ubuntu: (12.04: precise,
12.10: quantal, 13.04: raring, 13.10: saucy, 14.04: trusty, 14.10: utopic, [full list](https://wiki.ubuntu.com/Releases)).

>>`deb http://repo.percona.com/apt VERSION main`

>>`deb-src http://repo.percona.com/apt VERSION main`

>Exit and save nano (press control+x, then type y and press Enter).

>Update your packages and install percona.
>>`sudo apt-get update`

>>`sudo apt-get install percona-server-server-5.5 percona-server-client-5.5 libmysqlclient-dev`

### Step 7 *Configuring MySQL:*
>Edit my.cnf (the location can vary, type `mysqld -v --help | grep -A 1 'Default options'` to find all the possible locations):
>>`sudo nano /etc/mysql/my.cnf`

>Add (or change them if they already exist ; they go under the [mysqld] section) the following:
>>`max_allowed_packet = 16M`

>>`group_concat_max_len = 8192`

>Consider raising the key_buffer_size to 256M to start, later on you can raise this more as your database grows.

---

>**[Mandatory]** Create a MySQL user.

>Never use the root user for your scripts.

>Log in to MySQL with the root user

>>`sudo mysql -u root -p`

>nzedb is the databasename, you can change this if you want.  
>Change YourMySQLServerHostName to the hostname of the server.  
If your MySQL server is local, use localhost. If remote, try the domain name or IP address.
It has been reported 127.0.0.1 does not work for the hostname.  
>Change YourMySQLUsername for the username you will use to connect to MySQL in nZEDb.  
>Do not remove the quotes on the name / hostname / password.

>>`GRANT ALL ON nzedb.* TO 'YourMySQLUsername'@'YourMySQLServerHostName' IDENTIFIED BY 'SomePassword';`

>**[Mandatory]** Add file permission to your MySQL user.

>The ALL permissions doesn't actually grant them all, you MUST add FILE:
>>`GRANT FILE ON *.* TO 'YourMySQLUsername'@'YourMySQLServerHostName';`

>Exit MySQL:
>>`quit;`

### Step 8 *Installing and configuring a web server:*
>You have many options. We will however show you 2 options, Apache2 or Nginx.
Only install Apache2 or Nginx, do not install both to avoid issues.

>*[Apache](http://httpd.apache.org/):*
>>`sudo apt-get install apache2`

>If you have installed PHP 7, you also need to install the following package:
>>`sudo apt-get install libapache2-mod-php7.0`

>Now you need to check if you have apache 2.2 or apache 2.4,
they require a different configuration.
>>`apache2 -v`

>**Apache 2.4**:
>*If you have Apache 2.2, scroll down lower.*

>Create a site configuration file:
>>`sudo nano /etc/apache2/sites-available/nZEDb.conf`

>Paste the following into it (changing your paths as required):

    <VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName localhost
        DocumentRoot "/var/www/nZEDb/www"
        LogLevel warn
        ServerSignature Off
        ErrorLog /var/log/apache2/error.log
        <Directory "/var/www/nZEDb/www">
            Options FollowSymLinks
            AllowOverride All
            Require all granted
        </Directory>
        Alias /covers /var/www/nZEDb/resources/covers
    </VirtualHost>

>Save and exit nano.

>Edit apache to allow overrides in the /var/www folder (or the folder you will put nZEDb into):
>>`sudo nano /etc/apache2/apache2.conf`

>Under `<Directory /var/www/>`, change `AllowOverride None` to `AllowOverride All`

>Save and exit nano.

>Disable the default site, enable nZEDb, enable rewrite, restart apache:
>>`sudo a2dissite 00-default`

>>`sudo a2dissite 000-default`

>>`sudo a2ensite nZEDb.conf`

>>`sudo a2enmod rewrite`

>>`sudo service apache2 restart`

>**Apache 2.2**
>*Skip this if you have apache 2.4*

>Create a site configuration file:
>>`sudo nano /etc/apache2/sites-available/nZEDb`

>Paste the following into it (changing your paths as required):

    <VirtualHost *:80>
        ServerAdmin webmaster@localhost
        ServerName localhost
        DocumentRoot "/var/www/nZEDb/www"
        LogLevel warn
        ServerSignature Off
        ErrorLog /var/log/apache2/error.log
        <Directory "/var/www/nZEDb/www">
            Options FollowSymLinks
            AllowOverride All
            Order allow,deny
            allow from all
        </Directory>
        Alias /covers /var/www/nZEDb/resources/covers
    </VirtualHost>

>Save and exit nano.

>Disable the default site, enable nZEDb, enable rewrite, restart apache:
>>`sudo a2dissite default`

>>`sudo a2ensite nZEDb`

>>`sudo a2enmod rewrite`

>>`sudo service apache2 restart`

---

>**Nginx:**

>(Optional) You might want to remove apache2 first:
>>`sudo apt-get remove apache2`

>Install Nginx:
>>`sudo apt-get install -y nginx`

>**[Optional - Start]**  
If you wish to install the newest stable version of Nginx, follow these steps.

>You can check if your current version is outdated compared to the [Nginx downloads page](http://nginx.org/en/download.html) by typing this command:
>>nginx -v

>Add the Nginx PPA:
>>`sudo add-apt-repository ppa:nginx/stable`

>Update your sources:
>>`sudo apt-get update`

>Install the latest version of Nginx:
>>`sudo apt-get install -y nginx`

>**[Optional - End]**

>Install php fpm, which sends the PHP files to Nginx:
>>`sudo apt-get install -y php5-fpm`

>Create a nginx configuration file for your nZEDb website:
>>`sudo nano /etc/nginx/sites-available/nZEDb`

>Paste the following into the file, change the settings as needed:
The server_name must be changed if you want to use a different hostname than localhost.
  Example: "server_name localhost 192.168.1.29 mydomain.com;" would work on all those 3.
The fastcgi_pass can be changed to TCP by uncommenting it, sockets are faster however.

    server {
        # Change these settings to match your machine.
        listen 80 default_server;
        server_name localhost;

        # These are the log locations, you should not have to change these.
        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        # This is the root web folder for nZEDb, you shouldn't have to change this.
        root /var/www/nZEDb/www/;
        index index.html index.htm index.php;

        # Everything below this should not be changed unless noted.
        location ~* \.(?:css|eot|gif|gz|ico|inc|jpe?g|js|ogg|oga|ogv|mp4|m4a|mp3|png|svg|ttf|txt|woff|xml)$ {
            expires max;
            add_header Pragma public;
            add_header Cache-Control "public, must-revalidate, proxy-revalidate";
        }

        location / {
            try_files $uri $uri/ @rewrites;
        }

        location ^~ /covers/ {
            # This is where the nZEDb covers folder should be in.
            root /var/www/nZEDb/resources;
        }

        location @rewrites {
            rewrite ^/([^/\.]+)/([^/]+)/([^/]+)/? /index.php?page=$1&id=$2&subpage=$3 last;
            rewrite ^/([^/\.]+)/([^/]+)/?$ /index.php?page=$1&id=$2 last;
            rewrite ^/([^/\.]+)/?$ /index.php?page=$1 last;
        }

        location /admin {
        }

        location /install {
        }

        location ~ \.php$ {
            include /etc/nginx/fastcgi_params;

            # Uncomment the following line and comment the .sock line if you want to use TCP.
            #fastcgi_pass 127.0.0.1:9000;
            fastcgi_pass unix:/var/run/php5-fpm.sock;

            # The next two lines should go in your fastcgi_params
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
    }

>Save and exit nano.

>If you have changed the fastcgi_pass to tcp (127.0.0.1:9000), you must edit www.conf to listen on it instead of sockets:
>>`sudo nano /etc/php5/fpm/pool.d/www.conf`
Change `listen = /var/run/php5-fpm.sock` to `listen = 127.0.0.1:9000`
Save and exit nano.

>Create a log folder if it does not exist:
>>`sudo mkdir -p /var/log/nginx`

>>`sudo chmod 755 /var/log/nginx`

>Delete the default Nginx site:
>>`sudo unlink /etc/nginx/sites-enabled/default`

>Make nZEDb the default Nginx site:
>>`sudo ln -s /etc/nginx/sites-available/nZEDb /etc/nginx/sites-enabled/nZEDb`

>Restart Nginx and php5-fpm:
>>`sudo service nginx restart`

>>`sudo service php5-fpm restart` or `sudo /etc/init.d/php5-fpm restart`

---
### Step 8.1 *Add your user to the www-data group*
>Regardless of which web server you use, you should add your user to the www-data group so that you may create/edit files belonging to the group. Replace $USER for your username, if you will not use the current user for nzedb.
>>`sudo usermod -a -G www-data $USER`

>This requires you to log back in before it takes effect. Do so now or before the Aquiring nZEDb step.
>>`sudo reboot`


### Step 9 *Configuring PHP:*

>Open php.ini for the CLI SAPI (for PHP7 /etc/php7.0/cli/php.ini):
>>`sudo nano /etc/php5/cli/php.ini`

>Change the following settings:
>>`max_execution_time = 120`

>The following can be set to `-1` if you have a large amount of system RAM (>=8GB):
>>`memory_limit = 1024M`

>Change your timezone from a list of timezones [here](http://php.net/manual/en/timezones.php). **Remove the preceding ;**
>>`date.timezone = YourLocalTimezone`

>Enable error logging (Needed when reporting bugs)
>>`error_reporting = E_ALL`

>>`log_errors = On`

>>`error_log = php-errors.log`


>Close and save this file.

>Open the Web SAPI php.ini (for PHP7 /etc/php7.0/).
If you have installed Apache2: `sudo nano /etc/php5/apache2/php.ini`
If you have installed Nginx:   `sudo nano /etc/php5/fpm/php.ini`
>Change the settings using the same settings as the CLI SAPI.

>Restart Apache2 or PHP-FPM (if you use nginx for example):
>>`sudo service apache2 restart`

>>`sudo service php5-fpm restart`

### Step 10 *Installing extra software:*

>*[Unrar](http://en.wikipedia.org/wiki/Unrar):*

>You can install Unrar from the repositories, but it's quite old (version 4):
>> `sudo apt-get install unrar`

>You can also install it by downloading the newest version (recommended, as some RAR files require version 5+):
>Go to http://www.rarlab.com/download.htm, look for the newest unrar version (5.21 when this was written), right click it and copy the link.
>Replace the link below with the one you copied:
>>`mkdir -p ~/new_unrar && cd ~/new_unrar`

>>`wget http://www.rarlab.com/rar/rarlinux-x64-5.2.1.tar.gz`

>>`tar -xzf rarlinux*.tar.gz`

>>`sudo mv /usr/bin/unrar /usr/bin/unrar4`

>>`sudo mv rar/unrar /usr/bin/unrar`

>>`sudo chmod 755 /usr/bin/unrar`

>>`cd ~/ && rm -rf ~/new_unrar`

---

>*[7zip](http://www.7-zip.org/):*
>>`sudo apt-get install p7zip-full`

---

>*[Mediainfo](http://mediaarea.net/en/MediaInfo):*

>Go to http://mediaarea.net/en/MediaInfo/Download/Ubuntu, download the deb files for
libmediainfo, libzen0 and mediainfo (CLI)

>You can download by right clicking on them, copy link, then type `wget` and paste the link after.

>Once you have all 3 deb files, install them by typing `sudo dpkg -i` followed by the name of the file.
>You may have to install libzen0 package first. If so do:
>>`sudo apt-get install libzen0`

---

>*[Lame](http://lame.sourceforge.net/):*
>>`sudo apt-get install lame`

---

>*[FFmpeg](http://www.ffmpeg.org/) or [avconv](http://libav.org/avconv.html):*

>On newer versions of ubuntu (14.04+) you can install avconv:
>>`sudo apt-get install libav-tools`

>You can alternatively install ffmpeg:
>>(manual compilation)
https://trac.ffmpeg.org/wiki/CompilationGuide/Ubuntu

>>(automated compilation, possibly unmaintained)
https://github.com/jonnyboy/installers/blob/master/compile_ffmpeg.sh

---

>[Cache servers](https://github.com/nZEDb/nZEDb_Misc/blob/master/Guides/Various/Cache/Guide.md)

>After git cloning and seting up the indexer, edit nzedb/config/settings.php, change the various Cache settings. Guide [here](https://github.com/nZEDb/nZEDb_Misc/blob/master/Guides/Various/Cache/Guide.md).

---

>*[yEnc](http://en.wikipedia.org/wiki/YEnc):*

>You have 3 choices:

>simple_php_yenc_decode is a PHP extension written in C++ which offers the best performance of the 3 options.
This is highly recommended as there is a massive performance boost over the PHP way. This is quite easy to install so it is worth it.

>yydecode is an application written in C, it decodes yEnc files, it offers moderate performance.
The results vary in terms of performance, this requires disk I/O since the yEnc data has to be written
to the disk. Mounting the folder to RAM (tmpfs) improves I/O but is still slower than simple_php_yenc_decode.

>Alternatively, nZEDb has a PHP method which decodes yEnc but has very poor performance, this is good if you can't get
simple_php_yenc_decode or yydecode installed.

>You can change between any of the three at any time in site-edit part of the site if you have issues or want to test performance.

>*[simple_php_yenc_decode](https://github.com/kevinlekiller/simple_php_yenc_decode):*

>>`cd ~/`

>>`git clone https://github.com/kevinlekiller/simple_php_yenc_decode`

>>`cd simple_php_yenc_decode/`

>>`sh ubuntu.sh`

>>`cd ~/`

>>`rm -rf simple_php_yenc_decode/`

>*[yydecode](http://yydecode.sourceforge.net/):*

>>`cd ~/`

>>`mkdir -p yydecode`

>>`cd yydecode/`

>>`wget http://colocrossing.dl.sourceforge.net/project/yydecode/yydecode/0.2.10/yydecode-0.2.10.tar.gz`

>>`tar -xzf yydecode-0.2.10.tar.gz`

>>`cd yydecode-0.2.10/`

>>`./configure`

>>`make`

>>`sudo make install`

>>`make clean`

>>`cd ~/`

>>`rm -rf yydecode/`

---

### Step 11 *Acquiring nZEDb:*

>Switch your active group to 'www-data'.
>>`newgrp www-data`

>Switch to the system's www location.
>>`cd /var/www/`

>>This folder should have been created when apache2 was installed (by php5 dependencies). If, for whatever reason, it did not do:
>>>`mkdir -p /var/www`

>>>`sudo chown www-data:www-data /var/www`

>>>`sudo chmod 775 /var/www`

>[Install Composer](https://github.com/nZEDb/nZEDb/wiki/Installing-Composer)

>Set the permissions:

>During the setup (next step of this guide) you should set perms to 777 to make things easier, otherwise you might fail on step 2 of the web install:
>>`sudo chmod -R 755 /var/www/nZEDb/app/libraries`

>>`sudo chmod -R 755 /var/www/nZEDb/libraries`

>>`sudo chmod -R 777 /var/www/nZEDb/resources`

>>`sudo chmod -R 777 /var/www/nZEDb/www`

### Step 12 *Setting up nZEDb:*

>Open up an internet browser, head to `http://IpAddressOfYourServer/install` changing IpAddressOfYourServer for the IP of your server.
>>If this only shows you the web servers default page, you probably need to use a domain name of some kind.
>>Open your local hosts file (on the computer which you are trying to browse from) and add an entry for the target server.
>>>`sudo nano /etc/hosts`

>>>`IpAddressOfYourServer   <server_name_used_in_configuration>`

>Next, head to the edit site section,
turn on header compression if your server supports it,
put in paths to optional software, like unrar/ffmpeg/etc..

>To figure out the path to the optional software, type `which` followed by the name of the program.
Example: `which unrar`

>Signing up to all the API services(Amazon/Trakt/Rotten tomatoes/etc) is recommended, the keys we offer are used by many
nZEDb sites and are throttled so you will get almost no results from those.

### Step 13 *Indexing:*

##### Manual indexing:

>Head to the "view groups" admin section of the site. (http://IpAddressOfYourServer/admin/group-list.php)

>Turn on a group or two (alt.binaries.teevee is recommended).

>Move to the indexing script location in your terminal:
>>`cd /var/www/nZEDb/misc/update/`

>Download binary headers from usenet:
>>`php update_binaries.php`

>When that is complete, create releases and NZB files using those headers:
>>`php update_releases.php 1 true`

---

##### Automatic indexing:

>**Indexing using the screen sequential scripts:**

>First install screen, screen can let you run applications in the background while closing your terminal.
>>`sudo apt-get install screen`

>Move to the screen sequential folder:
>>`cd /var/www/nZEDb/misc/update/nix/screen/sequential/`

>Run the script using screen:
>>`screen sh simple.sh`
or
>>`screen sh simple-expanded.sh` 

>Now everything will run automatically.

>You can detach from the script, allowing you to close your terminal:
>>Press control and a together, let go and press d : `control+a d`

>If you want to re-attach to screen to see what is going on, type `screen -x`

>**Indexing using the Tmux scripts:**

>Install tmux, tmux is similar to screen but allows to have multiple terminals visible and other features.
>>`sudo apt-get install tmux time`

>On your website, head to the admin tmux page (http://IpAddressOfYourServer/admin/tmux-edit.php)

>Take your time and read through all the options attentively, I will however show the settings I used below.

>Set `Tmux Scripts Running` to `yes`.

>Set `Run Sequential` to `Basic Sequential`.

>Set `Update Binaries` to `Simple Threaded Update`.

>Set `Update Releases` to `Update Releases`.

>Set `Postprocess Additional` to `All`.

>Set `Postprocess Amazon` to `Yes`.

>Set `Postprocess Non-Amazon` to `Properly Renamed Releases`.

>Set `Decrypt Hash Based Release Names` to `All`.

>Set `Update TV and Theater Schedules` to `yes`.

>Click on `Save Tmux Settings` at the bottom of the page.

>In your terminal window (CLI), change current working directory to the tmux directory.
>>`cd /var/www/nZEDb/misc/update/nix/tmux/`

>Start the tmux script.
>>`php start.php`

>You can now detach from tmux using this keyboard combo(press control and a, let go press d): `control+a d`

>To re-attach to tmux, type `tmux attach`

---

>There are other automated scripts, you can open them in a text editor or ask around / do research to see what they do.

### Step 14 *Extra stuff:*

>**IRCScraper:**

>IRCSraper is a bot that connects to a IRC server to dowload PreDB information into your nZEDb SQL database.

>This helps renaming releases and gives extra information on your releases.

>Follow [this](https://github.com/nZEDb/nZEDb_Misc/blob/master/Guides/Various/ZNC/Guide.md) guide to set up ZNC, then follow [this](https://github.com/nZEDb/nZEDb_Misc/blob/master/Guides/Various/IRCScraper/Guide.md) guide to set up IRCScraper.

---

>**Comment sharing:**

>It is possible to share comments between nZEDb sites, please view the guide located [here](https://github.com/nZEDb/nZEDb_Misc/blob/master/Guides/Various/Sharing/Guide.md).

### Conclusion

>For questions, check the [FAQ](https://github.com/nZEDb/nZEDb/blob/master/docs/FAQ.txt)/[Wiki](https://github.com/nZEDb/nZEDb/wiki)/[Forum](http://forums.nzedb.com/) or join IRC, server [Synirc](https://www.synirc.net/servers) channel #nZEDb

>If you do not have a IRC client, we have a web IRC client on our website [here](http://forums.nzedb.com/index.php?action=chat).
