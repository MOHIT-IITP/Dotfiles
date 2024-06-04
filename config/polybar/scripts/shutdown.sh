#!/bin/bash

# Prompt the user for confirmation
read -p "Are you sure you want to shut down? (y/n): " choice

# Check if the user's choice is 'y' or 'Y' (case insensitive)
if [[ "$choice" =~ ^[yY]$ ]]; then
	echo "Shutting down..."
	sudo shutdown now
else
	echo "Shutdown aborted."
fi
