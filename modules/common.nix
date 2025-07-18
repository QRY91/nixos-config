# QRY Common System Configuration
# Shared between all hosts - the foundation of systematic engineering

{ config, lib, pkgs, inputs, ... }:

{
  # === Boot Configuration ===
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Keep more boot generations for rollback safety
  boot.loader.systemd-boot.configurationLimit = 20;

  # === Networking ===
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "1.1.1.1"    # Cloudflare
    "8.8.8.8"    # Google
    "9.9.9.9"    # Quad9
  ];

  # Enable SSH for remote access
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # === User Configuration ===
  users.users.qry = {
    isNormalUser = true;
    description = "QRY - Systematic Engineer";
    extraGroups = [
      "wheel"          # sudo access
      "networkmanager" # network management
      "audio"          # audio devices
      "video"          # video devices
      "docker"         # container management
      "gamemode"       # gaming optimizations
      "input"          # input devices
      "storage"        # storage management
    ];

    # Use zsh as default shell
    shell = pkgs.zsh;

    # SSH public keys (add your keys here)
    openssh.authorizedKeys.keys = [
      # "ssh-rsa AAAAB3NzaC1yc2E... your-key-here"
    ];
  };

  # === Shell Configuration ===
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # === Time and Locale ===
  time.timeZone = "America/New_York";  # Adjust for your timezone

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # === Audio System ===
  # PipeWire for modern audio - works great with Reaper
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # === Hardware Support ===
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # GPU acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # === Printing ===
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # === Development Environment ===
  # Enable Docker for containerization
  virtualisation.docker.enable = true;

  # Help with non-Nix binaries
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # Common libraries for development
    stdenv.cc.cc.lib
    zlib
    fuse3
    icu
    nss
    openssl
    curl
    expat
  ];

  # === Essential System Packages ===
  environment.systemPackages = with pkgs; [
    # System tools
    wget
    curl
    git
    vim
    tree
    htop
    btop
    lsof
    pciutils
    usbutils
    dmidecode

    # Archive tools
    unzip
    p7zip

    # Network tools
    nmap
    dig
    traceroute

    # File management
    ranger
    fzf
    ripgrep
    fd

    # System monitoring
    iotop
    nethogs

    # Development basics
    gnumake
    gcc
    pkg-config

    # Backup and sync
    rsync
    rclone

    # Security
    gnupg
    age

    # QRY philosophy: local-first, transparent, hackable
    sqlite
    jq
    yq
  ];

  # === Font Configuration ===
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.source-code-pro
    font-awesome
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  # === Security ===
  security.sudo.wheelNeedsPassword = false;  # Adjust based on your security preference

  # Firewall
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];  # SSH

  # === Environment Variables ===
  environment.sessionVariables = {
    # Enable Wayland for Electron apps
    NIXOS_OZONE_WL = "1";

    # Default editor
    EDITOR = "nvim";

    # QRY environment
    QRY_CONFIG_PATH = "$HOME/.config/qry";
    QRY_DATA_PATH = "$HOME/.local/share/qry";
  };

  # === Nix Configuration ===
  nix = {
    settings = {
      # Flakes and new nix command
      experimental-features = [ "nix-command" "flakes" ];

      # Build optimization
      auto-optimise-store = true;

      # Substituters for faster builds
      substituters = [
        "https://cache.nixos.org/"
        "https://nix-community.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    # Garbage collection
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  # === XDG Integration ===
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-gtk
    xdg-desktop-portal-wlr
  ];

  # === State Version ===
  # This should match your first NixOS installation
  system.stateVersion = "24.05";

  # === QRY Philosophy Integration ===
  # Local-first: most functionality works offline
  # Anti-fragile: easy rollbacks and experimentation
  # Systematic: everything is documented and reproducible
  # Junkyard engineering: safe to break and rebuild
}
