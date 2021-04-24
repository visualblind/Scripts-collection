ssh-keygen -b 4096 -t rsa
cat ~/.ssh/id_rsa.pub | ssh root@docker1 'cat - >> ~/.ssh/authorized_keys'
