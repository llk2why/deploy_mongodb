cp /etc/ssh/sshd_config /etc/ssh/sshd_config.backup

# => PermitRootLogin yes
# => PasswordAuthentication yes
sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

service sshd restart
(echo "$1";sleep 1;echo "$1") | passwd $2> /dev/null
usermod -a -G sudo $2