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
      # TODO rename this option to make naming more consistent
      isMobile = mkOption {
        default = false;
        type = with types; nullOr bool;
        example = true;
        description = ''
          Whether the computer is a mobile device.
          Displays more relevant information for mobile devices in the desktop environment if enabled.
	  Optimizes screen real estate.
        '';
      };
      enableAutoLogin = mkOption {
        default = false;
        type = with types; nullOr bool;
        example = true;
        description = ''
          Skip straight to the window manager.
        '';
      };
    };
  };

  config = {
    # Prepare configs for i3wm
    environment.etc."i3/config".text = import ./i3.nix
      { backgroundImage = if builtins.isNull cfg.backgroundImage then "" else "${cfg.backgroundImage}";
        enableGaps = !cfg.isMobile;
      };
    environment.etc."i3status.conf".text = import ./i3status.nix { enableMobileOptions = cfg.isMobile; };
    
    services = {
      xserver = {
        enable = true;
        # Swiss-German keyboard layout
        layout = "ch";
      
        # Use LightDM as display manager
        displayManager.lightdm = {
          enable = true;
          autoLogin = {
            enable = cfg.enableAutoLogin;
            user = "severin"; # TODO read this somehow? or pass as argument
          };
        };

        # Enable on mobile for touchpads, etc.
        libinput.enable = cfg.isMobile;
      
        # Use i3wm with a custom config
        windowManager = {
          i3 = {
            enable = true;
            configFile = "/etc/i3/config";
	    # Go for regular i3wm on smaller screens and mobile devices.
            package = if cfg.isMobile then pkgs.i3 else pkgs.i3-gaps;
            extraPackages = with pkgs; [
              dmenu
              i3status
              i3lock-fancy
            ];
          };
          default = "i3";
        };
      };
    
      compton = {
        enable = !cfg.isMobile;
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
        fira-code-symbols
        # Misc. fonts
        noto-fonts
        google-fonts
      ];
    };
  };
}
