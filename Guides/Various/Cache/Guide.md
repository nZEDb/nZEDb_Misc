####Notes:

>When the guide tells you to edit php.ini, on Ubuntu you must edit 2 files, one for the CLI SAPI, one for the web SAPI.  
>On Ubuntu, the CLI php.ini is here: `/etc/php5/cli/php.ini`,  
>the apache2 php.ini is here: `/etc/php5/apache2/php.ini`,  
>the fpm php.ini is here (if you use nginx): `/etc/php5/fpm/php.ini`  
>On other operating systems, there might be only 1 php.ini

####Igbinary:
>Install dependencies:
>>`sudo apt-get install php5-dev gcc make`

>Download the source code:
>>`cd ~/`  
>>`git clone https://github.com/igbinary/igbinary.git`  
>>`cd ~/igbinary/`

>Compile:
>>`phpize`  
>>`./configure CFLAGS="-O2 -g" --enable-igbinary`  
>>`make`  
>>`make test`  
>>`sudo make install`

>Add this to the "Dynamic Extensions" section of the php.ini files:
>>`extension=igbinary.so`

####APCu:
>Install it:
>>`sudo apt-get install php5-apcu`

>Enable APCu by adding the options below into the config file:
>>`sudo nano /etc/php5/cli/conf.d/20-apcu.ini`

    apc.enabled=1
    apc.shm_size=32M
    apc.ttl=7200
    apc.enable_cli=1
