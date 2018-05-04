let

in ''
general {
        colors = true
	color_good = "#888888"
	color_bad = "#888888"
        interval = 1
}
order += "cpu_usage"
#order += "ipv6"
order += "disk /"
#order += "run_watch DHCP"
#order += "run_watch VPN"
#order += "wireless _first_"
#order += "ethernet _first_"
#order += "battery 0"
#order += "load"
order += "tztime local"


cpu_usage {
	format = "%usage"
}

wireless _first_ {
        format_up = "W: (%quality at %essid) %ip"
        format_down = "W: down"
}

ethernet _first_ {
        # if you use %speed, i3status requires root privileges
        format_up = "Eth: %ip"
        format_down = "Eth: down"
}

battery 0 {
        format = "%status %percentage %remaining"
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
