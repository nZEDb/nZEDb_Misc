ZNC Linux Guide
===============

### Notes:
>Most of this guide assumes you have debian or ubuntu,  
but will work on most linux distros if you change some commands.

NOTE: ZNC 1.x+ is required. ZNC 0.x is not supported.
See here to compile 1.x on Debian: https://shellfish.io/tutorial/1/how-to-install-znc-on-debian-7/

### Step 1 *Installation:*
>For other distros than Ubuntu, you can follow the guides [here](http://wiki.znc.in/Installation).

>Install the required app for adding PPA's:
>>`sudo apt-get install python-software-properties`

>Add the PPA:
>>`sudo add-apt-repository ppa:teward/znc`

>Update your sources:
>>`sudo apt-get update`

>Install ZNC:
>>`sudo apt-get install znc znc-dbg znc-dev znc-perl znc-python znc-tcl`

### Step 2 *Create the ZNC config file:*

>Run the ZNC config creation wizard:
>>`znc --makeconf`

>All these settings can be changed later on. I'll skip some obvious settings.

---

>*Port:*

>Chrome blocks default IRC ports (if you will use the Web Admin ZNC module).  
You can use port `6664` as the ZNC listen port.

---

>*SSL:*

>You can enable this, if your ZNC server is not local for example.

---

>*Global Modules:*

>Webadmin: This allows you to change ZNC settings on the web without restarting ZNC, recommended.

---

>*Username:*

>This is the username to login to the ZNC server.

>*Password:*

>This is the password to login to the ZNC server (this should be somewhat secure).

>*Nick:*

>This is the nick name on IRC.

>*Bind host:*

>You should set this to 0.0.0.0 or you might have problems.

>*Number of lines per channel*:

>This is how many lines of text on IRC ZNC will buffer in RAM 
(if you disconnect your client from ZNC and reconnect, ZNC will send the lines of text you missed while you were disconnected to your IRC client). I set this to 100.

---

>*User modules:*

>Webadmin: Recommended.

>chansaver: This saves all your settings when you leave or join a channel, recommended.

---

>*Network setup:*

>When you reach that part, type yes (it's no by default).

>Network: `synirc`

>Chansaver: `yes`

>Keepnick: `yes`

>Kickrejoin: `yes`

>IRC Server: `contego.ny.us.synirc.net`

>Port: `6697`

>Password: Leave empty.

>Does this server use SSL?: `yes`

>Would you like to add another server?: `yes`

>IRC Server: `toronto.on.ca.synirc.net`

>Port: `6697`

>Password: Leave empty.

>Does this server use SSL?: `yes`

>Would you like to add another server?: `no`

---

>*Channels:*

>Would you like to add a channel for ZNC to automatically join?: `yes`

>Channel name: `#nZEDbPRE`

>Would you like to add another channel?: `no`

>Would you like to set up another network?: `no`

>Would you like to set up another user?: `no`

---

>Launch ZNC now?: `yes`

### Step 3 *Configuring IRCScraper:*
>You can now follow the IRCScraper guide [here](https://github.com/nZEDb/nZEDb_Misc/tree/master/Guides/Various/IRCScraper/Guide.md).
