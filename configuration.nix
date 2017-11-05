# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    # Hardware scan
    ./hardware-configuration.nix
    
    # Hardened settings
    ./sys-configs/hardened.nix
    
    # OpenVPN
    ./sys-configs/openvpn.nix

    # Graphical environment
    ./pkg-configs/xserver.nix

  ];

  system.stateVersion = "17.03";

  # Use the GRUB 2 boot loader
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.enableCryptodisk = true;
  boot.kernelModules = [ "nouveau" "vboxdrv" "vboxnetflt" "vboxnetadp" ];
  virtualisation.virtualbox.host.enable = true;

  hardware.pulseaudio.enable = true;

  networking.hostName = "orbit";
  networking.wireless.enable = false;
  networking.enableIPv6 = true;

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
  services.syncthing = {
    enable = true;
    user = "sev";
    dataDir = "/hdd/sync";
  };

  # Firewall
  networking.firewall.allowedTCPPorts = [ 22000 3000 ];
  networking.firewall.allowedUDPPorts = [ 21027 ];
  networking.firewall.enable = true;

  # Me
  users.extraUsers.sev = {
    extraGroups = [ "wheel" "users" "video" "audio" "syncthing" ];
    isNormalUser = true;
    uid = 1000;
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
        # (import ./pkg-configs/vim.nix)
        bc
        bmon
        curl
        file
        gcc
        git
        gnumake
        gnupg1
        hexchat
        htop
        i7z
        kbfs
        moc
        nmap
        nodejs
        openvpn
        pciutils
        pulseaudioLight
        python35Packages.pip
        python35Packages.youtube-dl-light
        python3Full
        stack
        stow
        sudo
        syncthing
        tldr
        unzip
        update-resolv-conf
        vim
        wget
        whois
        zlib
      ];

      # When no Xorg installed
      noxorg = [
        tmux
      ];

      # Graphical pkgs
      xorg = [
        dmenu
        feh
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
        tdesktop
        thunderbird
        torbrowser
        transmission
        transmission_gtk
        virtualbox
        vlc
        xfce.terminal
      ];

    in common ++ (if config.services.xserver.enable then xorg else noxorg);
}
