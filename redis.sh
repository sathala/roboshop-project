source common .sh

print_head "Setup Redis Repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${LOG} 
status_check

print_head "Enable Redis 602 dbf Module"
dnf module enable redis:remi-602 -y &>>${LOG}
status_check

print_head "Install Redis"
yum install Redis -y &>>${LOG} 
status_check

print_head "Update Redis Listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf &>>${LOG} 
status_check


print_head "Enable Redis"
systemctl enable redis &>>${LOG}
status_check

print_head "Start Redis"
systemctl restart redis &>>${LOG}
status_check
