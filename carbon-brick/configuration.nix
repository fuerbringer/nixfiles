{ config, pkgs, ... }:

let
  userName = "severin";
in
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

      # Tmux
      ./pkg-configs/tmux.nix

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
  networking.extraHosts = (import ./hosts.nix);
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

  services.desktop = {
    isMobile = true;
    screenShotDest = "/home/${userName}/sync/scrot";
    screenShotRemote = "https://scrot.fuerbringer.info";
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

  system.stateVersion = "18.09";

  environment.systemPackages = with pkgs;
    let
      # Generic pkgs and imports
     common = [
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
        docker_compose
        emacs
        entr
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
        sc-im
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
        xclip
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
     ];

      # Graphical pkgs
     xorg = [
       anki
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
       zathura
     ];

    in
      common
      ++ haskell
      ++ manPages
      ++ (if config.services.xserver.enable then xorg else noxorg);
}
