{ config, lib, pkgs, ...}:

with lib; 

let
  cfg = config.services.desktop-dwm;
  susplock = pkgs.writeScriptBin "susplock" ''
    #!${pkgs.stdenv.shell}
    # requires "${pkgs.slock}/bin/slock" if programs.slock.enable = false
    slock & ${pkgs.systemd}/bin/systemctl suspend
  '';
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
    # Suckless config.def.h overrides
    nixpkgs.config.packageOverrides = pkgs: rec {
      st = pkgs.st.override {
        conf = builtins.readFile ./st.h;
      };
      slstatus = pkgs.slstatus.override {
        conf = builtins.readFile ./slstatus.h;
      };
      dwm = pkgs.dwm.override {
        patches =
        [ ./config.def.h.diff ];
      };
    };

    services = {
      xserver = {
        enable = true;
        # Swiss-German keyboard layout
        layout = "ch";
      
        displayManager =  {
          setupCommands = ''
            ${pkgs.slstatus}/bin/slstatus &
          '';
          lightdm = {
            enable = true;
          };
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

    programs.slock.enable = true;
    
    environment.systemPackages = with pkgs; [
      /* Suckless */
      slstatus
      st
      surf

      susplock
    ];
    
    fonts = {
      enableFontDir = true;
      fonts = with pkgs; [
        # Jap fonts
        ipafont
        mplus-outline-fonts
        noto-fonts-cjk
        # Terminal fonts
        source-code-pro
        terminus_font
        # Misc. fonts
        noto-fonts
        google-fonts
      ];
    };
  };
}
