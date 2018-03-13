{ config, lib, pkgs, ... }:

{
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];
  fileSystems."/home".options = [ "noatime" "nodiratime" "discard" ];
  
  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda1";
      preLVM = true;
      allowDiscards = true;
    }
  ];
}
