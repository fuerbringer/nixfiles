{ config, lib, pkgs, ...}:

with lib; 

let
  cfg = config.services.sudo2;
in {
  options.services = {
    sudo2 = {
      enableDumbMessage = mkOption {
        default = false;
        type = with types; nullOr bool;
        example = true;
        description = ''
          Enable a dumb message in the sudoers lecture file.
        '';
      };
    };
  };

  config = {
    environment.etc."sudoers.lecture".text = if cfg.enableDumbMessage 
      then import ./sudoers.lecture.nix
      else "";
    security.sudo = {
      extraConfig = if cfg.enableDumbMessage
        then "Defaults  lecture_file = /etc/sudoers.lecture"
        else "";
    };
  };
}
