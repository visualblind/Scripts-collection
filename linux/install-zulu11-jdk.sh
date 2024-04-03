# error functions
exiterr()  { echo -e "Error: $1" >&2; exit 1; }
exiterr2() { exiterr "'apt failed, install manually instead\nhttps://www.azul.com/downloads' failed."; }

# install the necessary dependencies
sudo apt -yq install gnupg curl || exiterr2

# add the azul public key
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9

# add the azul package to the apt repository
sudo apt-add-repository 'deb http://repos.azulsystems.com/ubuntu stable main' || exiterr2
sudo apt update

sudo apt install -y zulu-11 || exiterr2

# change default java to zulu 11
sudo update-alternatives --config java || exiterr

# test whether java is working or not
which java && java -version || exiterr "Cant find java location"
