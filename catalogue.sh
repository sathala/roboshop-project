script_location=$(pwd)
LOG=/tmp/roboshop.log


echo -e "\e[35m Configuring NodeJS repos\e{0n"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Install NodeJS repos\e{0n"
yum install nodejs -y&>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Add Application User\e{0n"
useradd roboshop &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

mkdir -p /app &>>${LOG}

echo -e "\e[35m Downloading App content\e{0n"
curl -L -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${LOG} 
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Cleaning Old Content\e{0n"
rm -rf /app/* &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[Extracting App Content\e{0n"
cd /app 
unzip /tmp/catalogue.zip &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Installing NodeJS Dependencies\e{0n"
cd /app  &>>${LOG}
npm install &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Configuring Catalogue Service File\e{0n"
cp ${script_location}/files/catalogue.service /etc/systemd/system/catalogue.service &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Reload systemD\e{0n"
systemctl daemon-reload &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Enable Catalogue service\e{0n"
systemctl enable catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Start Catalogue service\e{0n"
systemctl start catalogue &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Configuring Mongo Repo\e{0n"
cp ${script_location}/files/mongodb.repo /etc/yum.repos.d/mongodb.repo &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Install Mongo Client\e{0n"
yum install mongodb-org-shell -y &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi

echo -e "\e[35m Load Schema\e{0n"
mongo --host mongodb-dev.devopsk24.online </app/schema/catalogue.js &>>${LOG}
if [ $? -eq 0 ]; then
  echo SUCCESS
else
  echo FAILURE
fi




