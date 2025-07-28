#!/bin/bash

# Terminate any existing Polybar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch Polybar with the defined bars
# Replace 'base' with the bar you want to launch
polybar main &
polybar center  &
polybar right  &
polybar left  &
polybar right1  &
polybar right2  &
polybar main1 &
polybar center-01  &
polybar right-01  &
polybar right1-01  &
polybar right2-01  &

# Uncomment the following lines if you want to launch additional bars
# polybar indicators &
# polybar powermenu &
# polybar right &
# polybar workspaces &

echo "Polybar launched..."
