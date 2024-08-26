#!/bin/bash

# Fetch IP address
ip=$(ip -o -4 addr show enp10s0 | awk '{print $4}' | cut -d/ -f1)

# Check if we have an IP address
if [ -z "$ip" ]; then
    echo "No IP"
else
    echo "$ip"
fi

