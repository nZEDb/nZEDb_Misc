####Notes:

>You can install all 3 cache servers listed below, but only 1 can be configured to be used in nZEDb.  

>When the guide tells you to edit php.ini, on Ubuntu you must edit 2 files, one for the CLI SAPI, one for the web SAPI.  
>On Ubuntu, the CLI php.ini is here: `/etc/php5/cli/php.ini`,  
>the apache2 php.ini is here: `/etc/php5/apache2/php.ini`,  
>the fpm php.ini is here (if you use nginx): `/etc/php5/fpm/php.ini`  
>On other operating systems, there might be only 1 php.ini

####[Optional] Igbinary:
>This is an alternative to PHP's built in serializer.  
>The cache servers can be compiled or configured to use this.  
>To learn more, read the [documentation](https://github.com/igbinary/igbinary/blob/master/README.md).

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

####Redis:
>Install dependencies:
>>`sudo apt-get install php5-dev gcc make redis-server`

>Download the source:
>>`cd ~/`  
>>`git clone https://github.com/nicolasff/phpredis.git`  
>>`cd ~/phpredis/`

>Compile:
>>`phpize`

>If you installed igbinary:
>>`./configure --enable-redis-igbinary`  
>>`make`  
>>`sudo make install`

>If not:
>>`./configure`  
>>`make`  
>>`sudo make install`

>Add this to the "Dynamic Extensions" section of the php.ini files(**MAKE SURE THIS LINE IS UNDER igbinary.so IF YOU ARE USING igbinary**):
>>`extension=redis.so`

####Memcached:
>Install memcached:
>>`sudo apt-get install memcached`

>Install the PHP extension without Igbinary support:
>>`sudo apt-get install php5-memcached`

>Build memcached extension from source for Igbinary support:

>Install dependencies:
>>`sudo apt-get install wget php5-dev gcc make libmemcached-dev`

>Download the source code:
>>`cd ~/ && wget http://pecl.php.net/get/memcached`  
>>`mkdir -p memcached_source && tar -xzvf memcached -C memcached_source/ --strip-components 1 && cd memcached_source`  
>>`phpize`  
>>`./configure --enable-memcached-igbinary`  
>>`make`  
>>`make test`  
>>`sudo make install`

####APCu:
>Install it:
>>`sudo apt-get install php5-apcu`

>Enable APCu by adding the options below into the config file:
>>`sudo nano /etc/php5/cli/conf.d/20-apcu.ini`

    apc.enabled=1
    apc.shm_size=32M
    apc.ttl=7200
    apc.enable_cli=1

>See [here](https://php.net/manual/en/apc.configuration.php) for configuration options.

>If you installed igbinary, enable it for apc (add it to /etc/php5/cli/conf.d/20-apcu.ini):
>>`apc.serializer=igbinary`
