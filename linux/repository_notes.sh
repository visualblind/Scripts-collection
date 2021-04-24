sudo ln -s /home/visualblind/repository_dir /var/www/html/repository_dir
sudo mkdir -p /home/visualblind/repository_dir/dists/stable/main/binary
rsync -av /var/cache/apt/archives/ /var/www/html/repository_dir/dists/xenial/stable/main/binary

binary directory: /var/www/html/repository_dir/dists/xenial/stable/main/binary

gpg master key 89F0FCC3
gpg sub signing key 1692E04D

mkdir /home/visualblind/gpg-keys
gpg --export-secret-key 89F0FCC3 > /home/visualblind/gpg-keys/master-private.key
gpg --export 89F0FCC3 >> /home/visualblind/gpg-keys/master-private.key


Origin: Ubuntu
Label: Ubuntu
Suite: xenial
Version: 16.04
Codename: xenial
Date: Thu, 21 Apr 2016 23:23:46 UTC
Architectures: amd64 arm64 armhf i386 powerpc ppc64el s390x
Components: main restricted universe multiverse
Description: Ubuntu Xenial 16.04e

apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 89F0FCC3
add-apt-repository "deb http://192.168.239.128/ xenial main"