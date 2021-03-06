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
    };
  };

  config = {
    # Prepare configs for i3wm
    environment.etc."i3/config".text = import ./i3.nix
      { backgroundImage = if builtins.isNull cfg.backgroundImage then "" else "${cfg.backgroundImage}";
        enableGaps = !cfg.isMobile; # No big gaps on mobile
      };
    environment.etc."i3status.conf".text = import ./i3status.nix { enableMobileOptions = cfg.isMobile; };

    nixpkgs.config.packageOverrides = pkgs: rec {
      st = pkgs.st.override {
        conf = builtins.readFile ./st.h;
      };
    };
      
    # Zürich City
    location = {
      latitude = 47.3686;
      longitude = 8.5392;
    };
    
    services = {
      xserver = {
        enable = true;
        # Swiss-German keyboard layout
        layout = "ch";
      
        # Use LightDM as display manager
        displayManager.lightdm = {
          enable = true;
        };

        desktopManager.xterm.enable = false;

        # Enable on mobile for touchpads, etc.
        libinput.enable = cfg.isMobile;
      
        # Use i3wm with a custom config
        windowManager = {
          i3 = {
            enable = true;
            configFile = "/etc/i3/config";
            package = pkgs.i3-gaps;
            extraPackages = with pkgs; [
              dmenu
              i3status
              i3lock-fancy
            ];
          };
          default = "i3";
        };
      };
    
      redshift = {
        enable = true;
      };
    };
    
    environment.systemPackages = with pkgs; [
      st
    ];
    
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
