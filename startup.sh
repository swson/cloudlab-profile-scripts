#!/bin/bash

USERS="root `ls /users`"

# Setup password-less ssh between nodes
for user in $USERS; do
    if [ "$user" = "root" ]; then
        ssh_dir=/root/.ssh
    else
        ssh_dir=/users/$user/.ssh
    fi
    /usr/bin/geni-get key > $ssh_dir/id_rsa
    chmod 600 $ssh_dir/id_rsa
    chown $user: $ssh_dir/id_rsa
    ssh-keygen -y -f $ssh_dir/id_rsa > $ssh_dir/id_rsa.pub
    cat $ssh_dir/id_rsa.pub >> $ssh_dir/authorized_keys
    chmod 644 $ssh_dir/authorized_keys
    cat >>$ssh_dir/config <<EOL
    Host *
         StrictHostKeyChecking no
EOL
    chmod 644 $ssh_dir/config
done

# update the packages up to date
sudo apt update
# install default jdk
sudo apt install default-jdk -y
# set JAVA_HOME in ~/.bashrc
echo "export JAVA_HOME=$(readlink -f  $(which java) | sed "s:/bin/java::")" >> ~/.bashrc

## change permission to 
if [ -d "/mydata" ]; then
    sudo chmod 777 /mydata
fi
