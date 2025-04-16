#!/bin/bash
# Update and install Nginx
yum update -y
yum install -y nginx

# Create the /register directory and its content
mkdir -p /usr/share/nginx/html/register
cat << 'EOT' > /usr/share/nginx/html/register/index.html
<html>
<head>
<title>Register Page</title>
</head>
<body>
<h1>Welcome to the Registration Page!</h1>
<p>This is the register page served via ALB path-based routing.</p>
</body>
</html>
EOT

# Update Nginx config for /register path
cat << 'EOT' > /etc/nginx/conf.d/register.conf
server {
    listen 80;
    server_name _;
    location /register {
        root /usr/share/nginx/html;
        index index.html;
    }
}
EOT

# Restart Nginx to apply changes
systemctl enable nginx
systemctl restart nginx
