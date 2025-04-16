#!/bin/bash
# Update packages and install Nginx
sudo yum update -y
sudo yum install -y nginx
# Create a simple homepage
sudo mkdir -p /var/www/html
echo "<html>
<head><title>Homepage</title></head>
<body>
<h1>Welcome to the Homepage!</h1>
</body>
</html>" | sudo tee /var/www/html/index.html
# Update Nginx configuration to serve the custom homepage
sudo sed -i 's|root /usr/share/nginx/html;|root /var/www/html;|g' /etc/nginx/nginx.conf
# Start and enable Nginx
sudo systemctl enable nginx
sudo systemctl restart nginx