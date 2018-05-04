{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix

      # Desktop environment
      ./desktop

      # Sudo
      ./pkg-configs/sudo.nix

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

  swapDevices = [
    { device = "/swap1";
      size = 1024;
    }
  ];

  networking.hostName = "carbon-brick"; # Define your hostname.
  networking.networkmanager = {
    enable = true;
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.bash.enableCompletion = true;
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  networking.firewall.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.pulseaudio.enable = true;

  services.xserver.libinput.enable = true;
  services.desktop.backgroundImage = "/home/severin/sync/pics/wallpaper/abe1.jpg";

  services.syncthing = {
    enable = true;
    user = "severin";
    dataDir = "/home/severin/sync";
    openDefaultPorts = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.severin = {
    uid = 1000;
    extraGroups = [ "wheel" "video" "audio" "syncthing" ];
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
        nmap
        nodejs-8_x 
        openvpn
        #pandoc
        pciutils
        pulseaudioLight
        python35Packages.pip
        python35Packages.youtube-dl-light
        python3Full
        sshfs
        stack
        stow
        sudo
        syncthing
        #texlive.combined.scheme-full
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
        i3lock
        i3status
        keepassx2
        libreoffice
        linuxPackages.virtualbox
        mpv
        redshift
        screenfetch
        scrot
        #tdesktop
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
