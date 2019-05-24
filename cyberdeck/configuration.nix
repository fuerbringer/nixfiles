{ config, pkgs, ... }:

let
  userName = "severin";
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Desktop environment
      ./desktop-dwm

      # Custom sudo
      ./sudo

      # Zshell
      ./pkg-configs/zsh.nix

      # Tmux
      ./pkg-configs/tmux.nix

      # Aliases
      ./aliases.nix
    ] ++ (if builtins.pathExists ./secrets/networkShares.nix then [ ./secrets/networkShares.nix ] else []);
  

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  nix.gc.automatic = true;
  nix.optimise.automatic = true;
  nix.useSandbox = true;

  boot.cleanTmpDir = true;

  networking.hostName = "cyberdeck";
  networking.networkmanager = {
    enable = true;
  };
  networking.extraHosts = (import ./hosts.nix);

  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de_CH-latin1";
    defaultLocale = "en_US.UTF-8";
  };

  time.timeZone = "Europe/Zurich";

  environment.variables = {
    TERMINAL = "st";
    EDITOR = "vim";
  };

  networking.firewall.enable = true;

  hardware.pulseaudio.enable = true;

  services.desktop-dwm = {
    isMobile = true;
  };
  services.sudo2.enableDumbMessage = true;

  services.openssh.enable = false;
  services.syncthing = {
    enable = true;
    user = userName;
    dataDir = "/home/${userName}/sync/syncthing_config";
    openDefaultPorts = true;
  };

  services.cron = {
    enable = true;
    systemCronJobs = [
      "0,15,30,45 * * * * ${userName} ${pkgs.offlineimap}/bin/offlineimap"
    ];
  };

  services.printing = {
    enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.severin = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "syncthing" "docker" ];
    group = "users";
    isNormalUser = true;
    initialPassword = "nepnep3"; # Just the initial passwd
    shell = "${pkgs.zsh}/bin/zsh";
  };

  system.stateVersion = "19.03";

  environment.systemPackages = with pkgs;
    let
      # Generic pkgs and imports
     common = [
        (import ./pkgs/bc-dl)
        (import ./pkgs/linkhandler)
        (import ./pkgs/upscrot)
        alsaUtils
        aspell
        aspellDicts.de
        aspellDicts.en
        aspellDicts.fr
        bash
        bc
        bind
        binutils
        bmon
        curl
        entr
        file
        gcc
        git
        gnumake
        gnupg1
        htop
        libreoffice
        lm_sensors
        moc
        msmtp
        neomutt
        newsboat
        nix-prefetch-git
        nmap
        nodejs-8_x 
        offlineimap
        pandoc
        pciutils
        pulseaudioLight
        python35Packages.youtube-dl-light
        sent
        sshfs
        stow
        sudo
        syncthing
        texlive.combined.scheme-full
        tldr
        unzip
        vim
        w3m
        wget
        whois
        xclip
        zlib
     ];

     manPages = [
        pkgs.man-pages
        pkgs.stdman
        pkgs.posix_man_pages
        pkgs.stdmanpages
     ];

     # When no Xorg installed
     noxorg = [
     ];

      # Graphical pkgs
     xorg = [
       arandr
       dmenu
       emacs
       feh
       firefox
       gimp
       keepassx2
       mpv
       neofetch
       scrot
       tdesktop
       vlc
       zathura
     ];

    in
      common
      ++ manPages
      ++ (if config.services.xserver.enable then xorg else noxorg);
}
