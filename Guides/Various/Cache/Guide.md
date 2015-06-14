Guide for installing cache servers for nZEDb.
-
####Notes:

>php.ini paths
>>On most operating systems there is 1 php.ini file. in /etc/php/php.ini for example.

>>On Debian / Ubuntu based distros there are multiple php.ini files you must edit.  
>>nZEDb is used on CLI and the web, so you need to edit the php.ini files for both of those.  
>>The CLI php.ini is usually here: `/etc/php5/cli/php.ini`,  
>>The web php.ini depends on the web server you use.  
>>For apache2, the corresponding php.ini is here: `/etc/php5/apache2/php.ini`,  
>>For most other web servers (like nginx), usually you use php-fpm, the corresponding php.ini is here: `/etc/php5/fpm/php.ini`

>Which cache server to install?
>>If you are unsure, you should install APCu.  
>>You can install all 3 cache servers listed below, but only 1 can be configured to be used in nZEDb.  
>>Some people will install multiple (different) cache servers because they have various projects that require different ones.  
>>In terms of performance, APCu should be the fastest, but it can only be used on the same server nZEDb runs.  
>>If run on the same server as nZEDb and using sockets, Memcached / Redis should be only slightly slower to APCu in terms of performance.  
>>You can install multiple Memcached or Redis servers, multiple (of the same type - 3 memcached servers for example) servers can be connected to, unlike APCu.

>How does caching benefit nZEDb?
>>nZEDb uses these cache servers to cache mainly MySQL query results.  
>>When a person loads up a web page, the MySQL database is queried, if you have turned on caching, the result of those queries is stored in the cache server(s), the next time some one loads the page, it will fetch the data from the cache server(s), which is faster than asking MySQL to create the data again.

>How do I configure nZEDb to use cache server(s)?
>>You must first copy the [www/settings.php.example](https://github.com/nZEDb/nZEDb/blob/master/www/settings.php.example) file to settings.php  
>>Open up the settings.php file in a text editor, scroll down to the "Cache Settings" section.  
>>Read the various settings descriptions and fill out the required details.

>PHP sessions:
>>This guide touches various options on PHP sessions.  
>>You can read about PHP sessions [here](https://php.net/manual/en/features.sessions.php).  
>>You might want to look at the various options for PHP sessions [here](https://php.net/manual/en/session.configuration.php#ini.session.serialize-handler).

---

####[Optional] Igbinary:
>This is an alternative to PHP's built in serializer.  
>The cache servers can be compiled/configured to use this.  
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

>(optional) Using igbinary as the session serializer.
>>Open the php.ini for the web SAPI, or the shared php.ini if you only have one.  
>>Look for `session.serialize_handler`  
>>Change it to `session.serialize_handler = igbinary`  

---

####Redis:
>This is a popular general purpose cache server, you can read about it [here](http://redis.io/topics/introduction).

>Install dependencies:
>>`sudo apt-get install php5-dev gcc make redis-server`

>Download the source:
>>`cd ~/`  
>>`git clone https://github.com/nicolasff/phpredis.git`  
>>`cd ~/phpredis/`

>Compile:
>>`phpize`
>>(If you installed/configured igbinary as noted in the above section)  
>>`./configure --enable-redis-igbinary`  
>>(If you have not installed igbinary)  
>>`./configure`  
>>`make`  
>>`sudo make install`

>Add this to the "Dynamic Extensions" section of the php.ini files(**MAKE SURE THIS LINE IS UNDER igbinary.so IF YOU ARE USING igbinary**):
>>`extension=redis.so`

>(optional) Using Redis as a PHP sessions store:
>>Open the php.ini for the web SAPI, or the shared php.ini if you only have one.  
>>Look for `session.save_handler`  
>>Change it to `session.save_handler = redis`  
>>Uncomment (remove the leading ;) `session.save_path`  
>>Change `session.save_path` to `session.save_path = "tcp://localhost:6379"` ; change the host / port based on your system.  
>>See [here](https://github.com/phpredis/phpredis#php-session-handler) if you want to use socket files or multiple Redis servers.

---

####Memcached:
>This is another popular general purpose caching server, read about it [here](http://memcached.org/about).

>Install memcached:
>>`sudo apt-get install memcached`

>Install the PHP extension without Igbinary support:
>>`sudo apt-get install php5-memcached`

>Alternatively, build memcached extension from source for Igbinary support:

>Install dependencies:
>>`sudo apt-get install wget php5-dev gcc make libmemcached-dev`

>Download the source code:
>>`cd ~/ && wget http://pecl.php.net/get/memcached`  
>>`mkdir -p memcached_source && tar -xzvf memcached -C memcached_source/ --strip-components 1 && cd memcached_source`

>Compile:
>>`phpize`  
>>`./configure --enable-memcached-igbinary`  
>>`make`  
>>`make test`  
>>`sudo make install`

>(optional) Using Memcached as a PHP sessions store:
>>Open the php.ini for the web SAPI, or the shared php.ini if you only have one.  
>>Look for `session.save_handler`  
>>Change it to `session.save_handler = memcached`  
>>Uncomment (remove the leading ;) `session.save_path`  
>>Change `session.save_path` to `session.save_path = "localhost:11211"` ; change the host / port based on your system.  
>>See [here](https://php.net/manual/en/memcached.sessions.php#112439) if you want to use socket files or multiple Memcached servers.

---

####APCu:
>This is a cache server which integrates into PHP. You can read it about [here](https://github.com/krakjoe/apcu#apcu)

>Install the php extension (this one supports igbinary):
>>`sudo apt-get install php5-apcu`

>Alternative compile instructions:
>>[See this link](https://github.com/krakjoe/apcu/blob/simplify/INSTALL#L13).

>See [here](https://php.net/manual/en/apc.configuration.php) for configuration options.

>Enable APCu by adding the options below into these config filse:
>>`/etc/php5/mods-available/apcu.ini` and 

    apc.enabled=1
    apc.shm_size=32M
    apc.ttl=7200
    apc.enable_cli=1
    
>On operating systems without the aforementioned file:
>>Add the previous lines (apc.enabled.. etc) to the "Module Settings" section of the php.ini files.  
>>Add `extension=apcu.so` to the "Dynamic Extension" section of the php.ini files (under igbinary.so if you have that).

>If you installed igbinary, enable it for apc (add this where you added the other options above):
>>`apc.serializer=igbinary`
