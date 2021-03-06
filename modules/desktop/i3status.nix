{ enableMobileOptions }:
let
  mobileOptions = if enableMobileOptions
    then
    { extraOptions = ''
        order += "wireless _first_"
        order += "battery 0"
        '';
      refreshRate = 2;
    }
    else
    { extraOptions = ''order += "ethernet _first_"'';
      refreshRate = 1;
    };
in ''
general {
  colors = false
  color_good = "#eeeeee"
  color_bad = "#eeeeee"
  interval = ${toString mobileOptions.refreshRate}
}

${mobileOptions.extraOptions}

order += "cpu_usage"
#order += "ipv6"
#order += "disk /"
#order += "run_watch DHCP"
#order += "run_watch VPN"
#order += "load"
order += "tztime local"

cpu_usage {
  format = "%usage"
}

wireless _first_ {
  format_up = "Wlan: %quality at %essid as %ip"
  format_down = "Wlan: down"
}

battery 0 {
  format = "%percentage"
}

ethernet _first_ {
  # if you use %speed, i3status requires root privileges
  format_up = "ETH: %ip"
  format_down = "Eth: down"
}

run_watch DHCP {
  pidfile = "/var/run/dhclient*.pid"
}

run_watch VPN {
  pidfile = "/var/run/vpnc/pid"
}

tztime local {
  format = "%Y-%m-%d %H:%M:%S"
}

load {
  format = "%1min"
}

disk "/" {
  format = "%avail"
}
''
