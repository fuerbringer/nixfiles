{ config, lib, pkgs, ... }:

with lib;
{
  services.dnsmasq.enable = true;
  services.openvpn = {
    servers = {
      default = {
        autoStart = true;
        # DISCLAIMER: Any certificates or other auth files included in the openvpn.conf
        # file must have an absolute path!
        config = builtins.readFile /etc/nixos/sys-configs/openvpn/openvpn.conf;
        up = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
        down = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
      };
    };
  };
}
