FROM greyltc/lamp-sshd-aur
RUN pacman -S wget unzip --noconfirm
RUN cd /srv/http && wget https://ja.wordpress.org/latest-ja.zip && unzip latest-ja.zip && rm latest-ja.zip && mv wordpress/* ./ && rm -rf wordpress/
RUN cat /srv/http/wp-config-sample.php | sed -e "s/database_name_here/wordpress/g" | sed -e "s/username_here/root/g" | sed -e "s/password_here//g" | sed -e "$ a define('FS_METHOD','direct');"> /srv/http/wp-config.php
RUN cat /etc/php/php.ini | sed -e 's/;date.timezone =/date.timezone ="Asia\/Tokyo"/g' | sed -e "s/;mbstring.language = Japanese/mbstring.language = Japanese/g" > /etc/php/php.ini
RUN /usr/bin/mysqld_safe --datadir=/var/lib/mysql & sleep 3s && mysql -u root -e "CREATE DATABASE wordpress;"
