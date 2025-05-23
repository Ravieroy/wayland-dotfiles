#!/usr/bin/env bash
# .scripts/awesome_autostart.sh
# Launch Apps when AwesomeWM starts.

function run {
  if ! pgrep -f $1 ;
  then
    $@&
  fi
}

# List the apps you wish to run on startup below preceded with "run"

# Policy kit (needed for GUI apps to ask for password)
run /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 &

# Start compositor
run picom --config ~/.config/picom/picom.conf &

# Start Network Manager Applet
run nm-applet &

# Screensaver
#run xscreensaver -no-splash &

#start firefox
#firefox &

# restore nitrogen wallpaper
nitrogen --restore &


