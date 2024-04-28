#!/bin/bash

sudo apt update
echo "Downloading latest nginx ...."
wget https://nginx.org/download/nginx-1.26.0.tar.gz
echo "Download completed."
echo "Extract...."
tar -zxvf nginx-1.26.0.tar.gz
echo "Installing build-essential ...."
cd nginx-1.26.0 && sudo apt install build-essential -y
echo "Installing additional library ...."
sudo apt install libpcre3 libpcre3-dev zlib1g zlib1g-dev libssl-dev -y
echo "Set configuration...."
sudo ./configure --sbin-path=/usr/bin/nginx --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --with-pcre --pid-path=/var/run/nginx.pid --with-http_ssl_module --with-http_v2_module
echo "Creating log files...."
sudo touch /var/log/nginx/error.log
sudo chmod -R 666 /var/log/nginx/error.log
sudo touch /var/log/nginx/access.log
sudo chmod -R 666  /var/log/nginx/access.log
echo "Make compile...."
sudo make
echo "Installing compiled nginx ...."
sudo make install
echo "Installation completed ...."
echo "Creating nginx service file ...."
sudo touch /lib/systemd/system/nginx.service
echo "Set nginx service...."
sudo tee /lib/systemd/system/nginx.service <<<'[Unit]
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
WantedBy=multi-user.target'

sudo echo "Restarting nginx...."
sudo systemctl restart nginx
sudo systemctl enable nginx
echo "Do you want to install php. y | n ...."
read py
if [[ ( $py == "y" || $py == "Y" ) ]]; then
    sudo apt install software-properties-common -y
    sudo add-apt-repository ppa:ondrej/php -y
    sudo apt update
    echo "Installing PHP. Select php version- 7.4| 8| 8.1| 8.2"
    read version
        if [ $version == "7.4" ]; then
        echo "installing php $version"
        sudo apt install php7.4-fpm -y
        echo "installing php extension ...."
        sudo apt install php7.4-common php7.4-mysql php7.4-xml php7.4-xmlrpc php7.4-curl php7.4-gd php7.4-imagick php7.4-cli php7.4-imap php7.4-mbstring php7.4-zip php7.4-intl -y
        elif [ $version -eq 8 ]; then
        echo "installing php $version"
        sudo apt install php8.0-fpm -y
        echo "installing php extension ...."
        sudo apt install php8.0-common php8.0-mysql php8.0-xml php8.0-xmlrpc php8.0-curl php8.0-gd php8.0-imagick php8.0-cli php8.0-imap php8.0-mbstring php8.0-zip php8.0-intl -y
        elif [ $version == "8.1" ]; then
        echo "installing php $version"
        sudo apt install php8.1-fpm -y
        echo "installing php extension ...."
        sudo apt install php8.1-common php8.1-mysql php8.1-xml php8.1-xmlrpc php8.1-curl php8.1-gd php8.1-imagick php8.1-cli php8.1-imap php8.1-mbstring php8.1-zip php8.1-intl -y
        elif [ $version == "8.2" ]; then
        echo "installing php $version"
        sudo apt install php8.2-fpm -y
        echo "installing php extension ...."
        sudo apt install php8.2-common php8.2-mysql php8.2-xml php8.2-xmlrpc php8.2-curl php8.2-gd php8.2-imagick php8.2-cli php8.2-imap php8.2-mbstring php8.2-zip php8.2-intl -y
        else
        echo "$version is not in this list. Please install it manually."
        fi
fi
echo "Do you want to install composer. y | n ...."
read cy
if [[ ( $cy == "y" || $cy == "Y" ) ]]; then
    cd ~ && echo "Installing composer ...."
    cd ~ && sudo curl -sS https://getcomposer.org/installer -o /tmp/composer-setup.php -y
    cd ~ && HASH=`curl -sS https://composer.github.io/installer.sig`
    cd ~ && echo $HASH
    cd ~ && php -r "if (hash_file('SHA384', '/tmp/composer-setup.php') === '$HASH') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
    cd ~ && sudo php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer
    cd ~ && composer
fi
echo "Do you want to install git. y | n ...."
read cy
if [[ ( $cy == "y" || $cy == "Y" ) ]]; then
    echo "Installing git ...."
    sudo apt install git -y
fi

echo "Do you want to install Let's encrypt free SSL. You can add domain later. y | n ...."
read cy
if [[ ( $cy == "y" || $cy == "Y" ) ]]; then
    echo "Updating system ...."
    sudo apt update -y && sudo apt upgrade -y
    echo "Running snap install core ...."
    sudo snap install core; sudo snap refresh core
    echo "Removing certbot ...."
    sudo apt remove certbot
    echo "Installing classic certbot ...."
    sudo snap install --classic certbot
    sudo ln -s /snap/bin/certbot /usr/bin/certbot
    echo "Installation done. You can run \n certbot --nginx -d domain.com"
fi

echo "Do you want to install MySQL. y | n ...."
read cy
if [[ ( $cy == "y" || $cy == "Y" ) ]]; then
    echo "Installing MySQL ...."
    sudo apt install mysql-server -y
    #echo "Configuring MySQL...."
    #echo "Creating root user with password '@Password123' "
#sudo mysql mysql<<EOFMYSQL
#ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '@Password123';
#EOFMYSQL
#echo "root user created."
#sudo mysql_secure_installation

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