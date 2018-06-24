{ backgroundImage, enableGaps }:
let
  background = if backgroundImage != "" then "exec feh --bg-fill ${backgroundImage}" else "";
  smartBorders = if enableGaps then "smart_borders on" else "";
  smartGaps = if enableGaps then "smart_gaps on" else "";
  barHeight = if enableGaps then "height 20" else ""; # Only on available i3-gaps
  gapsSettings = if enableGaps then ''
    for_window [class="^.*"] border pixel 1
    gaps inner 5
    gaps outer 1
    ''
    else "";
in ''
# i3 config file (v4)
#
# Please see http://i3wm.org/docs/userguide.html for a complete reference!

set $mod Mod1

# Font for window titles. Will also be used by the bar unless a different font
# is used in the bar {} block below.
font pango:Fira Code 11

# This font is widely installed, provides lots of unicode glyphs, right-to-left
# text rendering and scalability on retina/hidpi displays (thanks to pango).
#font pango:DejaVu Sans Mono 8

# Before i3 v4.8, we used to recommend this one as the default:
# font -misc-fixed-medium-r-normal--13-120-75-75-C-70-iso10646-1
# The font above is very space-efficient, that is, it looks good, sharp and
# clear in small sizes. However, its unicode glyph coverage is limited, the old
# X core fonts rendering does not support right-to-left and this being a bitmap
# font, it doesn’t scale on retina/hidpi displays.

# Use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec qterminal

# kill focused window
bindsym $mod+Shift+q kill

# start dmenu (a program launcher)
bindsym $mod+d exec dmenu_run
# There also is the (new) i3-dmenu-desktop which only displays applications
# shipping a .desktop file. It is a wrapper around dmenu, so you need that
# installed.
# bindsym $mod+d exec --no-startup-id i3-dmenu-desktop

# change focus
bindsym $mod+h focus left
bindsym $mod+j focus down
bindsym $mod+k focus up
bindsym $mod+l focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+j move left
bindsym $mod+Shift+k move down
bindsym $mod+Shift+l move up
bindsym $mod+Shift+odiaeresis move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+b split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+a focus parent

# focus the child container
#bindsym $mod+d focus child

# switch to workspace
bindsym $mod+1 workspace 1
bindsym $mod+2 workspace 2
bindsym $mod+3 workspace 3
bindsym $mod+4 workspace 4
bindsym $mod+5 workspace 5
bindsym $mod+6 workspace 6
bindsym $mod+7 workspace 7
bindsym $mod+8 workspace 8
bindsym $mod+9 workspace 9
bindsym $mod+0 workspace 10

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace 1
bindsym $mod+Shift+2 move container to workspace 2
bindsym $mod+Shift+3 move container to workspace 3
bindsym $mod+Shift+4 move container to workspace 4
bindsym $mod+Shift+5 move container to workspace 5
bindsym $mod+Shift+6 move container to workspace 6
bindsym $mod+Shift+7 move container to workspace 7
bindsym $mod+Shift+8 move container to workspace 8
bindsym $mod+Shift+9 move container to workspace 9
bindsym $mod+Shift+0 move container to workspace 10

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'You pressed the exit shortcut. Do you really want to exit i3? This will end your X session.' -b 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
  # These bindings trigger as soon as you enter the resize mode
  
  # Pressing left will shrink the window’s width.
  # Pressing right will grow the window’s width.
  # Pressing up will shrink the window’s height.
  # Pressing down will grow the window’s height.
  bindsym j resize shrink width 10 px or 10 ppt
  bindsym k resize grow height 10 px or 10 ppt
  bindsym l resize shrink height 10 px or 10 ppt
  bindsym odiaeresis resize grow width 10 px or 10 ppt
  
  # same bindings, but for the arrow keys
  bindsym Left resize shrink width 10 px or 10 ppt
  bindsym Down resize grow height 10 px or 10 ppt
  bindsym Up resize shrink height 10 px or 10 ppt
  bindsym Right resize grow width 10 px or 10 ppt
  
  # back to normal: Enter or Escape
  bindsym Return mode "default"
  bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
  status_command i3status --config /etc/i3status.conf

  position bottom
  separator_symbol ","
  ${barHeight}
  colors {
    background #0b000f
    statusline #888888
    separator #7fdd57

    # Type             border  background font
    focused_workspace  #7fdd57 #0b000f #dddddd
    active_workspace   #333333 #0b000f #dddddd
    inactive_workspace #333333 #0b000f #888888
    urgent_workspace   #aa0000 #990000 #ffffff
  }
}

# class                 border  backgr. text    indicator
#client.focused          #7fdd57 #666666 #dddddd #aaaaaa
client.focused          #7fdd57 #0b000f #ffffff #aaaaaa
client.focused_inactive #333333 #0b000f #888888 #484e50
client.unfocused        #222222 #0b000f #888888 #292d2e
client.urgent           #2f343a #900000 #ffffff #900000
client.placeholder      #000000 #0c0c0c #ffffff #000000
client.background       #0b000f

# Alsa
#bindsym $mod+Prior exec amixer -D pulse sset Master 5%+
#bindsym $mod+Next exec amixer -D pulse sset Master 5%-

# PulseAudio
bindsym $mod+Prior exec pactl set-sink-mute 1 false ; exec pactl set-sink-volume 1 +5%
bindsym $mod+Next exec pactl set-sink-mute 1 false ; exec pactl -- set-sink-volume 1 -5%

bindsym $mod+Control+l exec "i3lock-fancy --greyscale --pixelate"
bindsym $mod+Control+Shift+l exec "i3lock-fancy --greyscale --pixelate && systemctl suspend"

#bindsym $mod+Next exec sh -c "pactl set-sink-mute 1 false ; pactl set-sink-volume 1 -5%"
#exec xinput --set-prop 8 'libinput Accel Speed' -0.29
exec xinput set-prop 'Logitech G400s Optical Gaming Mouse' 'Device Accel Profile' -1

# i3 gaps
${gapsSettings}
${smartGaps}
${smartBorders}

# Background wallpaper
${background}
''
