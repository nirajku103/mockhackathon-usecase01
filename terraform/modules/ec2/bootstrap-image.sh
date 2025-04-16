#!/bin/bash
# Update and install Nginx
yum update -y
yum install -y nginx

# Create the /image directory and its content
mkdir -p /usr/share/nginx/html/image
cat << 'EOT' > /usr/share/nginx/html/image/index.html
<html>
<head>
<title>Image Directory</title>
</head>
<body>
<h1>Welcome to the Image Directory!</h1>
<p>This is the image directory served via ALB path-based routing.</p>
</body>
</html>
EOT

# Update Nginx config for /image path
cat << 'EOT' > /etc/nginx/conf.d/image.conf
server {
    listen 80;
    server_name _;
    location /image {
        root /usr/share/nginx/html;
        index index.html;
    }
}
EOT

# Restart Nginx to apply changes
systemctl enable nginx
systemctl restart nginx
