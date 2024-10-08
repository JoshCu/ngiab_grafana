#!/bin/bash

# Find the first .gpkg file in the specified directory
gpkg_file=$(find /ngen/ngen/data/config/ -name "*.gpkg" -type f | head -n 1)

# Check if a file was found
if [ -z "$gpkg_file" ]; then
    echo "No .gpkg file found in /ngen/ngen/data/config/"
    exit 1
fi

# find and replace the .gpkg name in the provisioning file
# /etc/grafana/provisioning/datasources/datasources.yaml
#       path: "/ngen/ngen/data/config/geopackage_name.gpkg"
sed -i "s|path: \"/ngen/ngen/data/config/.*.gpkg\"|path: \"$gpkg_file\"|g" /etc/grafana/provisioning/datasources/datasources.yaml

# run the grafana-server
exec /run.sh
