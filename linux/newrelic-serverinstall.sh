Server Agent:

echo deb http://apt.newrelic.com/debian/ newrelic non-free >> /etc/apt/sources.list.d/newrelic.list

wget -O- https://download.newrelic.com/548C16BF.gpg | apt-key add -

apt-get update

apt-get install newrelic-sysmond

nrsysmond-config --set license_key=9c813dafa8afe541734caf15d7c6b8cfefca3510

/etc/init.d/newrelic-sysmond start

/etc/newrelic/nrsysmond.cfg



APM:

echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | sudo tee /etc/apt/sources.list.d/newrelic.list

wget -O- https://download.newrelic.com/548C16BF.gpg | sudo apt-key add -

In your Apache config:

php_value newrelic.appname ‘mydomain.com’