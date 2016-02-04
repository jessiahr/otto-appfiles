#!/bin/bash
set -e

# Install cURL if we have to
apt-get update -y
apt-get install -y curl

# Install Docker
curl -sSL https://get.docker.com/ | sh

# Create the container
docker create -p 5432:5432 --name="kf_otto_db" postgres:9.1.0

# Write the service
cat >/etc/init/kf_otto_db.conf <<EOF
description "Docker container: kf_otto_db"

start on filesystem and started docker
stop on runlevel [!2345]

respawn

post-stop exec sleep 5

script
  /usr/bin/docker start kf_otto_db
end script
EOF

# Start the service
start kf_otto_db
