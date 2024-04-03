#!/usr/bin/env bash

date
echo 'vmware-toolbox-cmd stat balloon && vmware-toolbox-cmd stat swap'
vmware-toolbox-cmd stat balloon && vmware-toolbox-cmd stat swap

