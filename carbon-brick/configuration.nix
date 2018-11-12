{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Desktop environment
      ./desktop

      # Custom sudo
      ./sudo

      # Zshell
      ./pkg-configs/zsh.nix

      # Aliases
      ./aliases.nix
    ] ++ (if builtins.pathExists ./secrets/networkShares.nix then [ ./secrets/networkShares.nix ] else []);
  

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.device = "/dev/sda";
  
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  nix.gc.automatic = true;
  nix.optimise.automatic = true;
  nix.useSandbox = true;

  boot.initrd.luks.devices = [
    { name = "root";
      device = "/dev/sda2";
      preLVM = true;
      allowDiscards = true;
    }
  ];
  boot.cleanTmpDir = true;

  swapDevices = [
    { device = "/swap1";
      size = 2048;
    }
  ];

  networking.hostName = "carbon-brick";
  networking.networkmanager = {
    enable = true;
  };
  networking.extraHosts = (import ./nullrouted.nix);
  virtualisation = {
    docker = {
      enable = true;
    };
  };

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

  #services.desktop.backgroundImage = "/home/severin/mnt/pics/wallpaper/abe2.jpg";
  services.desktop.isMobile = true;
  services.desktop.enableAutoLogin = false;
  services.sudo2.enableDumbMessage = true;

  services.openssh.enable = false;
  services.syncthing = {
    enable = true;
    user = "severin";
    dataDir = "/home/severin/sync/syncthing_config";
    openDefaultPorts = true;
  };

  services.cron.systemCronJobs = [
    "0,15,30,45 * * * * offlineimap" # Fetch emails
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.severin = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "syncthing" "docker" ];
    group = "users";
    isNormalUser = true;
    initialPassword = "nepnep3"; # Just the initial passwd
    shell = "${pkgs.zsh}/bin/zsh";
  };

  system.stateVersion = "18.09";

  environment.systemPackages = with pkgs;
    let
      # Generic pkgs and imports
     common = [
        (import ./pkgs/linkhandler)
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
        docker_compose
        emacs
        file
        gcc
        git
        gnumake
        gnupg1
        htop
        mitscheme
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
        python35Packages.pip
        python35Packages.youtube-dl-light
        python3Full
        sent
        sshfs
        stack
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
        zlib
     ];

     manPages = [
        pkgs.man-pages
        pkgs.stdman
        pkgs.posix_man_pages
        pkgs.stdmanpages
     ];

     haskell = [
        cabal-install
        cabal2nix
        ghc
     ];

     # When no Xorg installed
     noxorg = [
        tmux
     ];

      # Graphical pkgs
     xorg = [
       arandr
       audacity
       dmenu
       feh
       filezilla
       firefox
       gimp
       hexchat
       keepassx2
       libreoffice
       mpv
       mupdf
       neofetch
       qtox
       redshift
       scrot
       tdesktop
       thunderbird
       torbrowser
       vlc
     ];

    in
      common
      ++ haskell
      ++ manPages
      ++ (if config.services.xserver.enable then xorg else noxorg);
}
