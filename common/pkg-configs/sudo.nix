{ pkgs, ...}:

{

environment.etc."sudoers.lecture".text = import ./sudoers.lecture.nix;

security.sudo = {
  extraConfig = ''
    Defaults  lecture_file = /etc/sudoers.lecture
  '';
};

}
