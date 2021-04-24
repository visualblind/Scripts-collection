#!/bin/bash

USER_COUNT=1000

echo "use ipplan;"
echo "#delete from users;"
echo "#delete from grp;"
echo "#delete from usergrp;"

for ((m=0 ; m < $USER_COUNT ; m++))
do
       USERNAME=user$m
       GROUP=group$m
       echo "insert into ipplan.users values('$USERNAME','$USERNAME
Description','fakepassword');"
       echo "insert into ipplan.grp values('$GROUP
Description','$GROUP','Y','1');"
done

for ((m=0; m < $USER_COUNT; m++))
do
       GROUP=group$m;
       USERNAME=user$m;
               echo "insert into ipplan.usergrp values('$USERNAME','$GROUP');"
done

