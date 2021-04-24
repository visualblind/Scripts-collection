Install requirements for phpbrew
apt-get update
apt-get upgrade
apt-get build-dep php5
apt-get install -y php5 php5-dev php-pear autoconf automake curl build-essential libxslt1-dev re2c libxml2 libxml2-dev php5-cli bison libbz2-dev libreadline-dev
apt-get install -y libfreetype6 libfreetype6-dev libpng12-0 libpng12-dev libjpeg-dev libjpeg8-dev libjpeg8  libgd-dev libgd3 libxpm4 libltdl7 libltdl-dev
apt-get install -y libssl-dev openssl
apt-get install -y gettext libgettextpo-dev libgettextpo0
apt-get install -y php5-cli
apt-get install -y libmcrypt-dev
apt-get install -y libreadline-dev

Install phpbrew
curl -L -O https://github.com/phpbrew/phpbrew/raw/master/phpbrew
chmod +x phpbrew
sudo mv phpbrew /usr/bin/phpbrew
Initialise phpbrew, update and install PHP 5.4
phpbrew init
phpbrew known --update
phpbrew update
Here we choose PHP 5.4.34, but you can change this to any version that is available as listed by the above commands - like 5.5.22.

phpbrew install 5.4.34 +default
phpbrew install 5.4.27 +default +mysql 
phpbrew install 5.4.27 +mysql +pdo +apxs2=/usr/bin/apxs2
Switch the default PHP version to 5.4
phpbrew switch php-5.4.34
phpbrew switch php-5.4.27
If it shows Invalid Argument, try phpbrew switch 5.4.34 instead.

Check your PHP version
php -v


CentOS 5.11 x64 HVM
u>rmD>8Y

sudo resize2fs /dev/sda1