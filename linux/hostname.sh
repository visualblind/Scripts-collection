• Edit /etc/hostname and add your unqualified hostname:
boson

• Edit /etc/hosts:
sudo vi /etc/hosts

• Add an entry of your desired hostname by replacing boson.dev.local boson where boson.dev.local is the fully qualified hostname and boson is hostname.
127.0.1.1       boson.dev.local boson

• Restart the hostname service:
service hostname restart

• Test your configuration by opening a terminal and enter the below commands:
hostname
• This should output non-FQDN hostname

hostname -f
• This should output FQDN hostname
