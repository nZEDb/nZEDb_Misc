IRCScraper Setup Guide
======================

### Notes:

>Importing [this](http://forums.nzedb.com/index.php?topic=1614.0) PreDB dump before starting is recommended.

>ZNC is recommended, please go through the ZNC guide [here](https://github.com/nZEDb/nZEDb_Misc/tree/master/Guides/Various/ZNC/Guide.md) first.

### Step 1 *Copying the settings file:*
>Move to the nZEDb root folder:
>>`cd /var/www/nZEDb/`

>Copy ircscraper_settings_example.php to ircscraper_settings.php:
>>`cp nzedb/config/ircscraper_settings_example.php nzedb/config/ircscraper_settings.php`

### Step 2 *Editing the settings file:*
>Open the settings file with a text editor:
>>`nano nzedb/config/ircscraper_settings.php`

>Change `$username` to the username you want.  
ie: `$username = 'myBot';`  
(on ZNC this would be the "username" to log in)

>If you have set up ZNC, change `SCRAPE_IRC_SERVER`  
to the IP address of the ZNC server 
(if the server is local, use localhost or 127.0.0.1).

>If you have a server that requires SSL or TLS, change  
`SCRAPE_IRC_PORT` to the requires port and set  
`SCRAPE_IRC_TLS` to true.

>If your ZNC server requires a password, change  
`SCRAPE_IRC_PASSWORD` from false to 'yourPassword'

>If you want to ignore categories, formulate a regex  
and enter it in `SCRAPE_IRC_CATEGORY_IGNORE`.  
Click [here](http://forums.nzedb.com/index.php?topic=1625.msg9602#msg9602) for a basic guide on formulating your own  
regex.

>If you want to ignore certain source, change  
`SCRAPE_IRC_SOURCE_IGNORE` sources from false to true.

>Exit and save nano (control+x)

### Step 3 *Starting the scraper:*

>**NON TMUX USERS:**

>Using screen is recommended so you can close  
your terminal/ssh session and keep the scraper running:
>>`sudo apt-get install screen`

>Run the scraper in screen:
>>`screen php misc/IRCScraper/scrape.php true`

>To detach from the screen session, press the following keyboard combination:
>>Control and A together, then let go and press D

>**TMUX USERS:**

>Head to the tmux-edit page of your web site (http://IpAddressOfYourServer/admin/tmux-edit.php).

>Change `Enable IRCScraper` to `yes`.

>Save your settings at the bottom of the page.

### Step 4 **[OPTIONAL]** *Setting up a script to start and check if the scraper is running (NON TMUX USERS):*
>You can set up a simple shell script to continuously check if the scraper is still running.

>Create a empty shell script:
>>nano misc/IRCScraper/run.sh

>Paste the following into it:

    #!bin/sh
    while :
    do
        if ! screen -list | grep -q "ircscraper"; then
                screen -dmS ircscraper /usr/bin/php /var/www/nZEDb/misc/IRCScraper/scrape.php true
        fi
        sleep 300
    done

>Exit and save nano (control+x)

>Stop the running scraper from step 3:
>>`killall screen`

>Make the new shell script executable:
>>`chmod +x misc/IRCScraper/run.sh`

>You can add this script as a cron job or daemon(rc.d script) or manually start it:
>>`screen sh misc/IRCScraper/run.sh`

### *Troubleshooting:*
>If you have issues, try running with debugging:
>>`php misc/IRCScraper/scrape.php true false true`

>Try a different server: [server list](https://www.synirc.net/servers)

>Try a different username, the username might be too long or already used or contain invalid characters.

>If you are running a ZNC server, your username/password might  
be wrong. Also depending on how ZNC is set up, `SCRAPE_IRC_PASSWORD` might need this format : 'username:password'
 
