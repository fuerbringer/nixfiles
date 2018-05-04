{ config, lib, pkgs, ...}:

with lib; 

let
  cfg = config.services.desktop;
in {
  options.services = {
    desktop = {
      backgroundImage = mkOption {
        default = null;
        type = with types; nullOr str;
        example = "/path/to/image.png";
        description = "Path to the desktop wallpaper image (must be supported by pkgs.feh).";
      };
    };
    isMobile = {
      backgroundImage = mkOption {
        default = false;
        type = with types; nullOr bool;
        example = true;
        description = ''
          Whether the computer is a mobile device.
          Displays more relevant information for mobile devices in the desktop environment if enabled.
        '';
      };
    };
  };

  config = {
    # Prepare configs for i3wm
    environment.etc."i3/config".text = import ./i3.nix
      { backgroundImage =
          if builtins.isNull cfg.backgroundImage then ""
          else "${cfg.backgroundImage}";
        enableThinWindowBorders = true;
      };
    environment.etc."i3status.conf".text = import ./i3status.nix { enableMobileOptions = true; };
    
    services = {
      xserver = {
        enable = true;
        # Swiss-German keyboard layout
        layout = "ch";
      
        # Use LightDM as display manager
        displayManager.lightdm.enable = true;
      
        # Use i3wm with a custom config
        windowManager = {
          i3 = {
            enable = true;
            configFile = "/etc/i3/config";
            package = pkgs.i3-gaps;
          };
          default = "i3";
        };
      };
    
      compton = {
        enable = true;
        extraOptions = ''
          opacity-rule = [ "95:class_g = 'qterminal'" ];
        '';
      };
    
      redshift = {
        enable = true;
      
        # Zürich City
        latitude = "47.3686";
        longitude = "8.5392";
      };
    };
    
    
    fonts = {
      enableFontDir = true;
      # fontconfig.cache32Bit = true;
    
      fonts = with pkgs; [
        # Jap fonts
        ipafont
        mplus-outline-fonts
        noto-fonts-cjk
        # Terminal fonts
        source-code-pro
        terminus_font
        fira-code
        # Misc. fonts
        noto-fonts
        google-fonts
      ];
    };
  };
}
