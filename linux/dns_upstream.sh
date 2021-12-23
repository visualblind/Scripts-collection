DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2} ');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'organization'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2} ');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'organization'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2} ');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") 
whoami
dig whoami.ds.akahelp.net +short A
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2} ');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'organization'
whoami
whois $(dig whoami.akamai.net +short) | grep -i 'Organization:'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2} ');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'organization'
whois $(dig whoami.akamai.net +short) | grep -i 'organization:'
dig whoami.akamai.net +short
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'organization'
$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS")
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS")
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}')
$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}')
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'netname'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'descr'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'netname:'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $( echo $DNS|tr -d '"' ) | grep -i 'organization'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $( echo $DNS|tr -d '"' ) | grep -i 'netname'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $( echo $DNS|tr -d '"' ) | grep -i 'netname:'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $( echo $DNS|tr -d '"' ) | grep -i 'org'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $( echo $DNS|tr -d '"' ) | grep -i 'netname:'
whois $(dig whoami.akamai.net +short) | grep -i 'organization:'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2} ');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'organization'
whois $(dig whoami.akamai.net +short) | grep -i 'organization:'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $(sed -e 's/^"//' -e 's/"$//' <<<"$DNS") | grep -i 'netname:'
DNS=$(dig whoami.ds.akahelp.net +short TXT | awk '{print $2}');whois $( echo $DNS|tr -d '"' ) | grep -i 'netname:'
dig whoami.ds.akahelp.net
dig whoami.ds.akahelp.net TXT
dig whoami.ds.akahelp.net TXT +short
dig whoami.ds.akahelp.net +short TXT
dig whoami.ds.akahelp.net TXT
dig whoami.ds.akahelp.net
dig whoami.ds.akahelp.net TXT
dig whoami.ds.akahelp.net TXT @8.8.8.8
dig whoami.ds.akahelp.net TXT @8.8.8.8 +short
snap whoami
whois whoami.akamai.net
dig whoami.akamai.net
dig whoami.akamai.net +short
whois $(dig whoami.akamai.net +short)
history|grep whoami
dig whoami.akamai.net +short
history|grep whoami | awk -F"] " '{ if (NR <=47) print $2 }' > /home/visualblind/Documents/scripts/linux/dns_upstream.sh