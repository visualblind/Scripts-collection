############ DPKG ############

#Put a package on hold:
echo "package hold" | sudo dpkg --set-selections

#Remove the hold:
echo "package install" | sudo dpkg --set-selections

#Display the status of your packages:
dpkg --get-selections

#Display the status of a single package:
dpkg --get-selections | grep "package"

############ APT ############

#Hold a package:
sudo apt-mark hold package_name

#Remove the hold:
sudo apt-mark unhold package_name
