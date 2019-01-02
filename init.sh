#!/bin/bash 

# Requires Nginx installed and configured
# Run with sudo permissions: sudo bash initNginxServers.sh
# Supports only Ubuntu atm
# Load balancing runs on localhost:80


# USAGE:
# Start servers (e.g. dummy.sh)
# sudo bash init (Config nginx with servers)
# host:80 -> servers
# Remark: Change ports in ports.txt and host in variable host below.




DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
www=$DIR"/templates/www/."
sa=$DIR"/templates/sites-available/."
conf=$DIR"/templates/load-balancer.conf"

echo "Removing existing template"
rm -rf /var/www/server1/
rm -rf /var/www/server2/
rm -rf /var/www/server3/

rm -rf /etc/nginx/sites-available/server1
rm -rf /etc/nginx/sites-available/server2
rm -rf /etc/nginx/sites-available/server3


rm -rf /etc/nginx/sites-enabled/default
rm -rf /etc/nginx/conf.d/load-balancer.conf
echo "... ok"


echo "Adding template to system"
#cp  -a $www /var/www/ #Commented since we will use server instead
#cp -a $sa /etc/nginx/sites-available/ #Commented since we will use server instead
cp -a  $conf /etc/nginx/conf.d/
echo "... ok"

echo "Linking sa"
# Commented since we will use server instead
#sudo ln -s /etc/nginx/sites-available/server1 /etc/nginx/sites-enabled/ 
#sudo ln -s /etc/nginx/sites-available/server2 /etc/nginx/sites-enabled/
#sudo ln -s /etc/nginx/sites-available/server3 /etc/nginx/sites-enabled/
echo "... ok"


host="localhost";

# Load all ports and build line to insert into load-balance.config
loadBalanceHosts="";
while IFS= read -r line; 
do 
	adress="server $host"":""$line;";
	loadBalanceHosts="$loadBalanceHosts""$adress""\n";
	echo $adress; 
done < ports.txt
#echo $loadBalanceHosts; 

# Replance line in load-balancer.conf with above. Afterwards remove tmp-files.
sed  "2s/.*/$loadBalanceHosts/" /etc/nginx/conf.d/load-balancer.conf > /etc/nginx/conf.d/load-balancer2.conf
rm -rf /etc/nginx/conf.d/load-balancer.conf
mv /etc/nginx/conf.d/load-balancer2.conf /etc/nginx/conf.d/load-balancer.conf


# Restart
sudo nginx -t
sudo systemctl restart nginx

