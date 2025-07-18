# QRY Debbie (Test Desktop) Configuration
# Test environment for Framework 12 configuration development

{ config, lib, pkgs, inputs, ... }:

{
  # === Host Identification ===
  networking.hostName = "debbie";
  networking.hostId = "12345678";  # Generate with: head -c 8 /etc/machine-id

  # === Desktop Environment ===
  # Use GNOME for familiar testing environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Alternative: Use KDE Plasma (uncomment if preferred)
  # services.displayManager.sddm.enable = true;
  # services.desktopManager.plasma6.enable = true;

  # === Wayland Support ===
  # Enable Wayland for modern display protocol
  programs.wayland.enable = true;

  # === Test-Specific Packages ===
  environment.systemPackages = with pkgs; [
    # Desktop utilities
    gnome.gnome-tweaks
    gnome.dconf-editor

    # File managers
    nautilus

    # Text editors for testing
    gedit

    # Terminal emulators
    gnome.gnome-terminal
    alacritty

    # Web browsers for testing
    firefox
    google-chrome

    # Development testing
    vscodium

    # Graphics testing
    mesa-demos
    glxinfo

    # Audio testing
    pavucontrol

    # System monitoring
    gnome.gnome-system-monitor

    # File compression for testing
    file-roller

    # Image viewers
    eog

    # Video players
    vlc
    totem

    # Office suite for testing
    libreoffice

    # Archive management
    unzip
    zip

    # Network tools
    networkmanager-openvpn
    networkmanager-vpnc

    # Printing
    system-config-printer

    # Bluetooth
    bluez
    bluez-tools

    # Testing utilities
    stress
    memtester

    # Performance monitoring
    iotop
    powertop

    # Hardware information
    lshw
    hwinfo
    inxi

    # QRY testing tools
    tree
    watch

    # Screenshot tools
    gnome.gnome-screenshot

    # Calculator
    gnome.gnome-calculator

    # Archive manager
    gnome.file-roller
  ];

  # === GNOME Configuration ===
  services.gnome = {
    # Enable essential GNOME services
    core-shell.enable = true;
    sushi.enable = true;        # File previews
    tracker.enable = true;      # File indexing
    tracker-miners.enable = true;
  };

  # Exclude some GNOME applications to keep it lean
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    cheese           # Webcam tool
    gnome-music
    epiphany         # Web browser (we have Firefox)
    geary            # Email client
    gnome-characters
    tali             # Poker game
    iagno            # Go game
    hitori           # Sudoku game
    atomix           # Puzzle game
  ];

  # === Hardware Configuration Hints ===
  # These will be overridden by hardware-configuration.nix

  # Enable firmware updates
  services.fwupd.enable = true;

  # Enable microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # === Power Management ===
  # Conservative power management for testing
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "powersave";
  };

  # === Testing-Specific Services ===

  # Enable SSH for remote testing
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = true;  # Allow password auth for testing
      PermitRootLogin = "no";
    };
  };

  # Enable Avahi for network discovery
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # === Development Testing Environment ===

  # Enable Docker for container testing
  virtualisation.docker.enable = true;

  # Enable libvirtd for VM testing
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # === Fonts for Testing ===
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    proggyfonts
  ];

  # === Testing User Configuration ===
  users.users.qry = {
    extraGroups = [
      "libvirtd"       # VM management
      "docker"         # Container management
      "dialout"        # Serial port access
    ];
  };

  # === Debugging and Development ===

  # Enable core dumps for debugging
  systemd.coredump.enable = true;

  # Enable performance events for profiling
  boot.kernel.sysctl."kernel.perf_event_paranoid" = lib.mkDefault 1;

  # === Test Environment Variables ===
  environment.sessionVariables = {
    # Mark this as test environment
    QRY_ENVIRONMENT = "test";
    QRY_HOST = "debbie";

    # Testing configurations
    QRY_TEST_MODE = "enabled";
    QRY_DEBUG_MODE = "enabled";

    # Desktop environment
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
  };

  # === Network Configuration ===
  # Use NetworkManager for easy wireless testing
  networking.networkmanager.enable = true;
  networking.wireless.enable = false;  # Disable wpa_supplicant in favor of NetworkManager

  # === Firewall Testing ===
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22    # SSH
      80    # HTTP testing
      443   # HTTPS testing
      3000  # Development servers
      8080  # Alternative HTTP
      8888  # Jupyter/development
    ];

    # Allow ping for network testing
    allowPing = true;
  };

  # === Time Synchronization ===
  services.chrony.enable = true;

  # === Localization Testing ===
  i18n.defaultLocale = "en_US.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # === Audio Testing ===
  # Audio configuration is in common.nix, but we ensure it's enabled
  sound.enable = true;

  # === Testing Automation ===

  # Systemd service to run tests on boot
  systemd.services.qry-test-environment = {
    description = "QRY Test Environment Setup";
    after = [ "multi-user.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      User = "qry";
      Group = "users";
      ExecStart = pkgs.writeShellScript "qry-test-setup" ''
        # Create test directories
        mkdir -p /home/qry/test/{logs,results,configs}

        # Log test environment startup
        echo "QRY Test Environment started at $(date)" >> /home/qry/test/logs/startup.log

        # Test basic functionality
        echo "Testing basic commands..." >> /home/qry/test/logs/startup.log

        # Test applications are available
        for app in blender godot4 reaper steam ollama; do
          if command -v $app >/dev/null 2>&1; then
            echo "✓ $app available" >> /home/qry/test/logs/startup.log
          else
            echo "✗ $app not found" >> /home/qry/test/logs/startup.log
          fi
        done

        echo "Test environment setup complete" >> /home/qry/test/logs/startup.log
      '';
    };
  };

  # === System Monitoring for Testing ===

  # Enable detailed logging for debugging
  services.journald.extraConfig = ''
    SystemMaxUse=1G
    RuntimeMaxUse=100M
    Storage=persistent
  '';

  # === Testing Aliases and Shortcuts ===
  environment.shellAliases = {
    # Test commands
    test-apps = "echo 'Testing applications...' && blender --version && godot4 --version && reaper --version";
    test-audio = "speaker-test -t sine -f 1000 -l 1";
    test-graphics = "glxgears";
    test-steam = "steam --version";
    test-ai = "ollama list";

    # System testing
    test-system = "inxi -Fxz";
    test-hardware = "lshw -short";
    test-performance = "sysbench cpu --threads=4 run";

    # QRY testing methodology
    test-query = "echo 'What are we testing and why?'";
    test-refine = "echo 'How can we improve the test?'";
    test-yield = "echo 'What did we learn from this test?'";
  };

  # === Testing Documentation ===
  environment.etc."qry/test-environment".text = ''
    QRY Test Environment - Debbie
    =============================

    This is a test environment for validating the QRY Framework 12 configuration.

    Test Checklist:
    - [ ] Desktop environment loads correctly
    - [ ] All applications start (Blender, Godot, Reaper, Steam)
    - [ ] Audio system works (PipeWire)
    - [ ] Gaming works (Steam)
    - [ ] AI tools work (Ollama)
    - [ ] Development environment functional
    - [ ] Network connectivity
    - [ ] Hardware acceleration

    Logs are stored in: /home/qry/test/logs/

    To run tests: sudo systemctl start qry-test-environment
    To view logs: journalctl -u qry-test-environment
  '';

  # === State Version ===
  system.stateVersion = "24.05";
}
