{ config, pkgs, ... }:

let
  timeWasters =
  [ "www.reddit.com"
    "reddit.com"
    "youtube.com"
    "www.youtube.com"
  ];
in
{
  imports = [
    <nixpkgs/nixos/modules/profiles/hardened.nix>

    # Generated hardware scan
    ./hardware-configuration.nix

    # Volume and boot settings
    ./boot-volumes.nix
    
    # OpenVPN
    ./sys-configs/openvpn.nix

    # Desktop environment
    ./desktop

    # Sudo
    ./pkg-configs/sudo.nix

    # Zshell
    ./pkg-configs/zsh.nix
  ];

  system.stateVersion = "18.03";

  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.enableCryptodisk = true;
  boot.kernelModules = [ "nouveau" "vboxdrv" "vboxnetflt" "vboxnetadp" ];
  boot.cleanTmpDir = true;

  virtualisation = {
    virtualbox = {
      host.enable = true;
    };
    docker = {
      enable = true;
    };
  };

  hardware.pulseaudio.enable = true;

  networking.hostName = "orbit";
  networking.wireless.enable = false;
  networking.enableIPv6 = true;
  networking.hosts = {
    "127.0.0.1" = timeWasters;
  };

  # Internationalisation
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "de_CH-latin1";
    defaultLocale = "en_US.UTF-8";
  };

  # TZ
  time.timeZone = "Europe/Zurich";

  # Services
  services.journald.extraConfig = "SystemMaxUse=1024M";
  services.printing.enable = false;
  services.openssh.enable = false;
  services.i2p.enable = true;
  services.mongodb.enable = true;
  services.syncthing = {
    enable = true;
    user = "sev";
    dataDir = "/hdd/sync";
    openDefaultPorts = true;
  };
  services.desktop.backgroundImage = "/hdd/sync/media/pics/wallpaper/abe2.jpg";

  services.nixosManual = {
    showManual = true;
    # browsers = "{pkgs.w3m}/bin/w3m" # default
  };

  # Firewall
  networking.firewall.allowedTCPPorts =
    [ 3000  # Local development
    ];
  networking.firewall.allowedUDPPorts = [ ];
  networking.firewall.enable = true;

  # Me
  users.extraUsers.sev = {
    extraGroups = [ "wheel" "users" "video" "audio" "syncthing" "docker" ];
    isNormalUser = true;
    uid = 1000;
    shell = "${pkgs.zsh}/bin/zsh";
  };

  nixpkgs.config = {
    allowUnfree = false; 
  };

  environment.variables = {
    TERMINAL = "xfce4-terminal";
    EDITOR = "vim";
  };

  environment.systemPackages = with pkgs;
    let
      # Generic pkgs and imports
      common = [
        ansible
        bash
        bc
        bmon
        curl
        docker
        docker_compose
        file
        gcc
        git
        gnumake
        gnupg1
        hexchat
        httpie
        htop
        i7z
        kbfs
        moc
        nixops
        nmap
        nodejs-8_x 
        openvpn
        pandoc
        pciutils
        pulseaudioLight
        python35Packages.pip
        python35Packages.youtube-dl-light
        python3Full
        stack
        stow
        sudo
        syncthing
        texlive.combined.scheme-full
        tldr
        unzip
        update-resolv-conf
        vim
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
        linuxPackages.virtualbox
        mpv
        redshift
        screenfetch
        scrot
        tdesktop
        thunderbird
        torbrowser
        transmission
        transmission_gtk
        virtualbox
        vlc
        lxqt.qterminal
      ];

    in
      common ++ manPages ++ (if config.services.xserver.enable then xorg else noxorg);
}
