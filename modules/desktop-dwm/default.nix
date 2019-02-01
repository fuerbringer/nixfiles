{ config, lib, pkgs, ...}:

with lib; 

let
  cfg = config.services.desktop-dwm;
in {
  options.services = {
    desktop-dwm = {
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
    # Suckless st config.def.h overrides
    nixpkgs.config.packageOverrides = pkgs: rec {
      st = pkgs.stdenv.lib.overrideDerivation pkgs.st (oldAttrs : {
        configFile = builtins.readFile ./config.def.h; # st config # TODO: Move this elsewhere, not WM specific
      });
      # dwm = pkgs.dwm.override {
      #   patches =
      #   [ ./dwm-pertag-6.1.diff ];
      # };
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
      
        windowManager = {
          dwm = {
            enable = true;
          };
          default = "dwm";
        };
      };
    
      redshift = {
        enable = true;
      
        # Zürich City
        latitude = "47.3686";
        longitude = "8.5392";
      };
    };
    
    environment.systemPackages = with pkgs; [
      st
      (import ./../pkgs/dwm-statusbar)
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
