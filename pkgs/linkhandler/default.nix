{ config, pkgs, ... }:

let
  linkhandler = pkgs.writeScriptBin "linkhandler" ''
    #!${pkgs.stdenv.shell}
    
    if [[ $DISPLAY  ]]; then 
      x=$(printf "mpv\\nwget\\nfeh\\nbrowser\\nw3m" | ${pkgs.dmenu}/bin/dmenu -i -p "Open link with what program?")
      
      case "$x" in
        mpv) ${pkgs.utillinux}/bin/setsid ${pkgs.mpv}/bin/mpv -quiet "$1" >/dev/null 2>&1 & ;;
        wget) ${pkgs.wget}/bin/wget "$1" >/dev/null 2>&1 ;;
        browser) xdg-open "$1" & ;;
        feh) ${pkgs.utillinux}/bin/setsid ${pkgs.feh}/bin/feh "$1" >/dev/null 2>&1 & ;;
        w3m) ${pkgs.w3m}/bin/w3m "$1" ;;
      esac
    else
      ${pkgs.w3m}/bin/w3m "$1"
    fi
  '';
in
{
  config = {
    environment.systemPackages = with pkgs; [ linkhandler ];
  };
}
