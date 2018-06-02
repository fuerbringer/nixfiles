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
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.grub.device = "/dev/sda";
  
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

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
      size = 1024;
    }
  ];

  networking.hostName = "carbon-brick";
  networking.networkmanager = {
    enable = true;
  };
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
    TERMINAL = "xfce4-terminal";
    EDITOR = "vim";
  };

  networking.firewall.enable = true;

  hardware.pulseaudio.enable = true;

  services.desktop.backgroundImage = "/home/severin/sync/pics/wallpaper/abe2.jpg";
  services.desktop.isMobile = true;
  services.desktop.enableAutoLogin = false;
  services.sudo2.enableDumbMessage = true;

  services.openssh.enable = false;
  services.syncthing = {
    enable = true;
    user = "severin";
    dataDir = "/home/severin/sync";
    openDefaultPorts = true;
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

  system.stateVersion = "18.03";

  environment.systemPackages = with pkgs;
    let
      # Generic pkgs and imports
     common = [
        alsaUtils
        bash
        bc
        bmon
        curl
        docker_compose
        file
        gcc
        git
        gnumake
        gnupg1
        hexchat
        htop
        httpie
        i7z
        jekyll
        kbfs
        moc
        nmap
        nodejs-8_x 
        openvpn
        pciutils
        pulseaudioLight
        python35Packages.pip
        python35Packages.youtube-dl-light
        python3Full
        ruby
        sshfs
        stack
        stow
        sudo
        syncthing
        texlive.combined.scheme-basic
        tldr
        unzip
        update-resolv-conf
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

     # When no Xorg installed
     noxorg = [
        tmux
     ];

      # Graphical pkgs
     xorg = [
        dmenu
        feh
        filezilla
        firefox
        gimp
        keepassx2
        libreoffice
        lxqt.qterminal
        mpv
        neofetch
        qtox
        redshift
        scrot
        thunderbird
        torbrowser
        vlc
     ];

    in
      common ++ manPages ++ (if config.services.xserver.enable then xorg else noxorg);
}
