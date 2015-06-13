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

>Edit php.ini
>>`sudo nano /etc/php5/cli/php.ini` (also edit the apache2 / fpm ones for the web server ex: /etc/php5/fpm/php.ini).

>Add this to the "Dynamic Extensions" section:
>>`extension=igbinary.so`
