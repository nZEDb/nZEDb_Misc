Ubuntu Web Guide. **WIP**
============
>This guide was designed for Ubuntu 12.04+ and derivatives (Linux Mint/Elemantary OS/etc.), using this guide on Debian or other Linux Distributions might or might not function. This guide might have errors or be obsolete by the time you read it, doing some research on your part on how to fix issues if they arise is required.

### Notes:
>In this guide you will see commands within grey rectangles, example:
`this is an example`  
When you see these, you must type them into a command line interface (terminal window).

> PHP 5.4 and MySQL 5.5 are the minimum required versions, 
but higher versions (PHP 5.5 and MySQL 5.6 to be exact) are recommended.

### Step 1 *Updating your operating system*:
>Update all your sources:
>>`sudo apt-get update`

---

>Upgrade your applications:
>>`sudo apt-get upgrade`

---

>**Optional:** Upgrade some other stuff (like the kernel).
>>`sudo apt-get dist-upgrade`

---

>You must now reboot your server.

### Step 2 *Installing pre-requisite software*:
>These programs will be used later on to install additional software.  
They might already be installed on your operating system.  
>>`sudo apt-get install software-properties-common`  
`sudo apt-get install python-software-properties`

### Step 3 **[Optional]** *Adding a repository for the newest PHP and Apache*:
>This will give you the latest PHP and Apache, PHP 5.5 is highly recomended, 
if you operating system does not having PHP 5.5, please add this repository.
>>`sudo apt-get install software-properties-common`  
`sudo add-apt-repository ppa:ondrej/php5`  
`sudo apt-get update`

### Step 4 *Installing PHP and the required extensions*:
> Note that some extensions might be missing here, 
see INSTALL.txt in the nZEDb docs folder for all the required extensions.  
>>`sudo apt-get install php5 php5-dev php5-json php-pear php5-gd php5-mysqlnd php5-curl`

### Step 5 **[Mandatory]** *Apparmor*:
>Apparmor restricts certain programs, on nZEDb it stops us from using the 
MySQL LOAD DATA commands. 
You can read more on Apparmor [here](http://en.wikipedia.org/wiki/AppArmor).

>*You have two options*:  

---

>Option 1: Making Apparmor ignore MySQL
>>`sudo apt-get install apparmor-utils`  
`sudo aa-complain /usr/sbin/mysqld`

---

>Option 2: Disabling Apparmor
>>`sudo update-rc.d apparmor disable`

---

>**You MUST reboot your server after doing this!**

### Step 6 *Installing a MySQL server and client*:
> You have multiple choices when it comes to a MySQL server and client,
you will need to do some research to figure out which is the best for you.
We recommend MariaDB for most people.

>[MySQL](http://dev.mysql.com/doc/refman/5.6/en/features.html):
>>`sudo apt-get install mysql-server mysql-client libmysqlclient-dev`

---

>[MariaDB](https://mariadb.com/kb/en/mariadb-versus-mysql-compatibility/):
>>`sudo apt-get install mariadb-server mariadb-client libmysqlclient-dev`

---

>[Percona](http://www.percona.com/software/percona-server/feature-comparison):  

> Add the repo key:
>>`sudo apt-key adv --keyserver keys.gnupg.net --recv-keys 1C4CBDCDCD2EFD2A`  

> Create a text file to put in the repo source:  
>>`sudo nano /etc/apt/sources.list.d/percona.list`

>Paste the deb and deb-src lines, replacing VERSION with the name of your ubuntu: (12.04: precise,
12.10: quantal, 13.04: raring, 13.10: saucy, 14.04: trusty, 14.10: utopic).

>>`deb http://repo.percona.com/apt VERSION main`  
`deb-src http://repo.percona.com/apt VERSION main`

>Exit and save nano (press control+x, then type y and press Enter).

>Update your packages and install percona.
>>`sudo apt-get update`  
`sudo apt-get install percona-server-server-5.5 percona-server-client-5.5 libmysqlclient-dev`

### Step 7 *Configuring MySQL*:
