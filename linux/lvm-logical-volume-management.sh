LV Path /dev/ubuntu1604-template-vg/root
Physical path 

lvextend –l +100%FREE /dev/ubuntu1604-template-vg/root

lvextend -L+100%  


vgextend ubuntu1604-template-vg /dev/sda3

lvextend -r -l +100%FREE /dev/ubuntu1604-template-vg/root