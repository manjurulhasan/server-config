#!/bin/bash
sudo apt update
echo "Downloading nginx package...."
wget http://nginx.org/download/nginx-1.23.1.tar.gz
echo "Download completed."
echo "Extract...."
tar -zxvf nginx-1.23.1.tar.gz
echo "Installing build-essential...."
cd nginx-1.23.1 && sudo apt install build-essential -y
echo "Installing additional library...."
sudo apt install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev -y
echo "Set configuration...."
sudo ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre --pid-path=/var/run/nginx.pid --with-http_ssl_module --with-http_v2_module
echo "Creating log files...."
sudo touch /var/log/nginx/error.log
sudo chmod -R 777 /var/log/nginx/error.log
sudo touch /var/log/nginx/access.log
sudo chmod -R 777  /var/log/nginx/access.log
echo "Make compile...."
sudo make
echo "Installing compiled nginx...."
sudo make install
echo "Installation completed...."
echo "Creating nginx service file...."
sudo touch /lib/systemd/system/nginx.service
echo "Set nginx service...."
sudo tee /lib/systemd/system/nginx.service <<<"[Unit]
Description=The NGINX HTTP and reverse proxy server
After=syslog.target network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target

[Service]
Type=forking
PIDFile=/run/nginx.pid
ExecStartPre=/usr/bin/nginx -t
ExecStart=/usr/bin/nginx
ExecReload=/usr/bin/nginx -s reload
ExecStop=/bin/kill -s QUIT $MAINPID
PrivateTmp=true

[Install]
WantedBy=multi-user.target
"
sudo echo "Restarting nginx...."
sudo systemctl restart nginx
echo "Do you want to install php. y for yes/ n for no ...."
read py
if [[ ( $py == "y" || $py == "Y" ) ]]; then
sudo apt install software-properties-common -y
sudo add-apt-repository ppa:ondrej/php -y
sudo apt update
echo "Installing PHP. Select php version- 7.4| 8| 8.1"
read version
    if [ $version == "7.4" ]; then
    echo "installing php $version ...."
    sudo apt install php7.4-fpm -y
    echo "installing php extension...."
    sudo apt install php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-imap php7.4-mbstring php7.4-zip php7.4-intl -y
    elif [ $version -eq 8 ]; then
    echo "installing php $version"
    sudo apt install php8.0-fpm -y
    echo "installing php extension...."
    sudo apt install php8.0-common php8.0-mysql php8.0-xml php8.0-xmlrpc php8.0-curl php8.0-gd php8.0-imagick php8.0-cli php8.0-imap php8.0-mbstring php8.0-zip php8.0-intl -y
    elif [ $version == "8.1" ]; then
    echo "installing php $version"
    sudo apt install php8.1-fpm -y
    echo "installing php extension...."
    sudo apt install php8.1-common php8.1-mysql php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-imap php8.1-mbstring php8.1-zip php8.1-intl -y
    else
    echo "$version not installed. Please install it manually."
    fi
fi
echo "Do you want to install composer. y for yes/ n for no ...."
read cy
if [[ ( $cy == "y" || $cy == "Y" ) ]]; then
    cd ~ && echo "Installing composer...."
    cd ~ && sudo curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php -y
    cd ~ && HASH=`curl -sS https://composer.github.io/installer.sig`
    cd ~ && echo $HASH
    cd ~ && php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    cd ~ && sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
    cd ~ && composer
fi
echo "Do you want to install git. y for yes/ n for no ...."
read cy
if [[ ( $cy == "y" || $cy == "Y" ) ]]; then
    echo "Installing git...."
    sudo apt install git -y
fi
echo "Do you want to install MySQL. y for yes/ n for no ...."
read cy
if [[ ( $cy == "y" || $cy == "Y" ) ]]; then
    echo "Installing MySQL...."
    sudo apt install mysql-server -y
    echo "Please install manually following this step."
    echo "sudo mysql"
    echo "mysql> ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Your_Password';"
    echo "mysql> exit"
    echo "sudo mysql_secure_installation"
fi
echo "Have a nice day."
sudo echo "################################################################"
sudo echo "#############    S C R I P T  C R E A T E D  B Y   #############"
sudo echo "#############                                      #############"
sudo echo "#############             S H A J I B              #############"
sudo echo "#############                                      #############"
sudo echo "################################################################"