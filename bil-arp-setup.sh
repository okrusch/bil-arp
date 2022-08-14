#! /usr/bin/bash

echo "Bil ReverseProxy SetUp Running...."

echo "We will start with a little bit of Information that is needed"

read -p "Enter the domain of your BTCPayServer: " domain

echo "Your domain is set to "       $domain

read -p "Enter your Email-Address: " email

echo "Your email is "       $email

read -p "What port is your BTCPayServer running on?" port

#install all dependicies

echo "Downloading and installing dependecies"

sudo apt update -y

sudo apt install python3-acme python3-certbot python3-mock python3-openssl python3-pkg-resources python3-pyparsing python3-zope.interface python3-certbot-nginx nginx nginx-extras nginx-common -y -f
sudo apt install --reinstall  python3-acme python3-certbot python3-mock python3-openssl python3-pkg-resources python3-pyparsing python3-zope.interface python3-certbot-nginx nginx nginx-extras nginx-commo>
sudo systemctl reload nginx.service
sudo sed -i 's/80 default_server/15080/g' /etc/nginx/sites-available/default

sudo apt install -f


echo "Dependencies installed succesfully"

read -p "Press enter to proceed"

sudo touch /etc/nginx/sites-available/bilpay
sudo cp /home/citadel/citadel/bil_arp/btcpay-nginx-template /etc/nginx/sites-available/bilpay
sudo chmod u+w /etc/nginx/sites-available/bilpay
sudo chmod a+w /etc/nginx/sites-available/bilpay

read -p "Press enter to proceed"

#alter domain variables

sudo sed -i "s/website_url/$domain/g" /etc/nginx/sites-available/bilpay
sudo sed -i "s/port_number/$port/g" /etc/nginx/sites-available/bilpay
sudo ln -s /etc/nginx/sites-available/bilpay /etc/nginx/sites-enabled/

read -p "Press enter to proceed"

#run all setup steps for reverse proxy

sudo nginx -t

sudo systemctl reload nginx.service

read -p "Press enter to proceed"

sudo certbot --nginx -d $domain -m $email --non-interactive --agree-tos --no-redirect

sudo sed -i 's/443/15443/g' /etc/nginx/sites-available/bilpay

sudo nginx -t

sudo systemctl reload nginx.service

echo "IF the certificate failed to be created it is most likely becaus your DNS A Record hasnt been propageted yet."

echo "The certificate script has now been added to a cronjob to executed once an our"

echo "Once the certificate has been created succesfully you can acces your BTCPayServer"

echo "The certificate will be renewd once a Month, when it is due for       renewal!"

#add cronjob for certbot

echo "If you havent revieved any errors, you should be seeing your new BTCPayServer on " $domain

echo "Your SetUp ist complete"

