{ pkgs, ...}:

{

# Prepare configs for i3wm
environment.etc."i3/config".text = import ./i3.nix;
environment.etc."i3status.conf".text = import ./i3status.nix;

services.xserver = {
  enable = true;
  # Swiss-German keyboard layout
  layout = "ch";

  # Use LightDM as display manager
  displayManager.lightdm.enable = true;

  # Use i3wm with a custom config
  windowManager.i3 = {
    enable = true;
    configFile = "/etc/i3/config";
  };

};

fonts = {
  enableFontDir = true;
  fontconfig.cache32Bit = true;

  fonts = with pkgs; [
    terminus_font
    source-code-pro
  ];
};

# Redshift screen
services.redshift = {
  enable = true;

  # Zürich City
  latitude = "47.3686";
  longitude = "8.5392";
};

}
