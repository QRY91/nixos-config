# QRY Framework 12 Configuration
# Production environment for systematic engineering and AI development

{ config, lib, pkgs, inputs, ... }:

{
  # === Host Identification ===
  networking.hostName = "framework12";
  networking.hostId = "87654321";  # Generate with: head -c 8 /etc/machine-id

  # === Desktop Environment ===
  # Minimal, productivity-focused desktop
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  # Wayland is enabled by default with GNOME

  # === Framework 12 Specific Hardware ===
  imports = [
    # Framework hardware support will be imported from flake.nix
    # inputs.nixos-hardware.nixosModules.framework-13-7040-amd  # Adjust for your model
  ];

  # === Framework 12 Optimizations ===
  boot.kernelParams = [
    # Framework 12 specific optimizations
    "mem_sleep_default=deep"     # Better suspend/resume
    "intel_pstate=active"        # Intel P-state driver
    "i915.enable_psr=1"          # Panel self refresh
    "i915.enable_fbc=1"          # Framebuffer compression

    # Performance optimizations
    "mitigations=auto"           # Security vs performance balance
    "quiet"                      # Clean boot
    "splash"                     # Boot splash
  ];

  # Latest kernel for Framework 12 support
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Framework specific kernel modules
  boot.kernelModules = [
    "framework_laptop"           # Framework laptop support
    "uvcvideo"                  # Camera support
    "btusb"                     # Bluetooth support
  ];

  # === Power Management ===
  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";  # Default to power savings
  };

  # Advanced power management
  services.thermald.enable = true;
  services.auto-cpufreq = {
    enable = true;
    settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };

  # TLP for laptop power management
  services.tlp = {
    enable = true;
    settings = {
      # CPU scaling
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # CPU energy performance
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # CPU boost
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # WiFi power saving
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # USB autosuspend
      USB_AUTOSUSPEND = 1;

      # Battery thresholds for Framework
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;
    };
  };

  # === Display Configuration ===
  services.xserver.dpi = 180;  # Framework 12 high DPI

  # HiDPI support
  environment.variables = {
    GDK_SCALE = "1.5";
    GDK_DPI_SCALE = "0.8";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1.2";
  };

  # === Framework Hardware Support ===
  hardware = {
    # Framework expansion card support
    firmware = with pkgs; [ linux-firmware ];

    # Enable all the things
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    # CPU microcode
    cpu.intel.updateMicrocode = true;

    # Bluetooth
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
        };
      };
    };

    # Graphics acceleration
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        intel-media-driver
        vaapiIntel
        intel-compute-runtime  # OpenCL
      ];
    };
  };

  # === Framework Specific Services ===
  services = {
    # Firmware updates
    fwupd.enable = true;

    # Better touchpad support
    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
        tapping = true;
        clickMethod = "clickfinger";
        accelProfile = "adaptive";
        accelSpeed = "0.3";
      };
    };

    # Fingerprint reader (if available)
    fprintd.enable = true;

    # Location services for automatic timezone
    geoclue2.enable = true;
  };

  # === Production Environment Packages ===
  environment.systemPackages = with pkgs; [
    # Framework utilities
    fw-ectool              # Framework EC tool

    # Power management tools
    powertop
    acpi
    tlp

    # Hardware monitoring
    lm_sensors
    psensor

    # Display tools
    arandr
    autorandr              # Display profile management

    # Battery monitoring
    upower

    # Performance monitoring
    intel-gpu-tools
    mesa-demos

    # Productivity applications
    firefox
    thunderbird            # Email client

    # Office suite
    libreoffice

    # PDF viewer
    evince

    # Image viewer
    eog

    # Archive manager
    file-roller

    # Calculator
    gnome.gnome-calculator

    # System monitor
    gnome.gnome-system-monitor

    # Settings
    gnome.gnome-control-center

    # Terminal
    gnome.gnome-terminal
    alacritty

    # File manager
    nautilus

    # Screenshot tool
    gnome.gnome-screenshot
    flameshot

    # Video player
    mpv

    # Audio control
    pavucontrol

    # Bluetooth manager
    blueman

    # Network manager
    networkmanagerapplet

    # Text editor
    gnome.gedit

    # Archive tools
    unzip
    zip
    p7zip

    # Framework specific tools
    stress                 # System stress testing
    memtester             # Memory testing
    hdparm                # Hard disk parameters
    smartmontools         # Drive health monitoring

    # Development productivity
    obsidian              # Knowledge management

    # Communication
    signal-desktop
    discord

    # Virtualization
    virt-manager

    # Container tools
    docker-compose
  ];

  # === GNOME Configuration for Productivity ===
  services.gnome = {
    core-shell.enable = true;
    sushi.enable = true;
    tracker.enable = true;
    tracker-miners.enable = true;
    gnome-keyring.enable = true;
  };

  # Remove unnecessary GNOME applications
  environment.gnome.excludePackages = with pkgs; [
    gnome-photos
    gnome-tour
    cheese
    gnome-music
    epiphany
    geary
    gnome-characters
    tali
    iagno
    hitori
    atomix
    gnome-software
    yelp
    gnome-logs
    gnome-maps
    gnome-weather
    gnome-contacts
    simple-scan
  ];

  # === Laptop-Specific Networking ===
  networking = {
    networkmanager = {
      enable = true;
      wifi.powersave = true;
    };

    # Disable wpa_supplicant in favor of NetworkManager
    wireless.enable = false;
  };

  # === Security Configuration ===
  security = {
    # Enable polkit for desktop integration
    polkit.enable = true;

    # Enable real-time kit for audio
    rtkit.enable = true;
  };

  # === Production Environment Variables ===
  environment.sessionVariables = {
    # Mark as production environment
    QRY_ENVIRONMENT = "production";
    QRY_HOST = "framework12";

    # Framework optimizations
    QRY_POWER_PROFILE = "adaptive";
    QRY_DISPLAY_SCALING = "1.5";

    # Production settings
    QRY_DEBUG_MODE = "disabled";
    QRY_TELEMETRY = "disabled";

    # Wayland preferences
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland,x11";
    XDG_SESSION_TYPE = "wayland";

    # HiDPI settings
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1.2";
    GDK_SCALE = "1.5";
    GDK_DPI_SCALE = "0.8";
  };

  # === Virtualization ===
  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = false;
      };
    };
  };

  # === User Configuration ===
  users.users.qry = {
    extraGroups = [
      "libvirtd"           # VM management
      "docker"             # Container management
      "video"              # Video devices
      "input"              # Input devices
    ];
  };

  # === Backup Strategy ===
  services.borgbackup.jobs.framework12 = {
    paths = [
      "/home/qry"
      "/etc/nixos"
      "/var/lib/docker"    # Docker volumes
    ];

    exclude = [
      "/home/qry/.cache"
      "/home/qry/.local/share/Trash"
      "/home/qry/Downloads"
      "*.pyc"
      "__pycache__"
      ".git"
      "node_modules"
      "target"             # Rust build directory
      ".next"              # Next.js build directory
    ];

    repo = "/home/qry/backups/framework12";
    compression = "auto,zstd";
    startAt = "02:00";     # 2 AM daily backup

    preHook = ''
      echo "Starting Framework 12 backup at $(date)"
      # Ensure we're on AC power before backup
      if [ "$(cat /sys/class/power_supply/ADP1/online)" != "1" ]; then
        echo "Not on AC power, skipping backup"
        exit 1
      fi
    '';

    postHook = ''
      echo "Framework 12 backup completed at $(date)"
      # Notify user of backup completion
      ${pkgs.libnotify}/bin/notify-send "Backup Complete" "Framework 12 backup finished successfully"
    '';
  };

  # === System Monitoring ===
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "systemd"
      "cpu"
      "meminfo"
      "diskstats"
      "filesystem"
      "loadavg"
      "netdev"
      "hwmon"              # Hardware monitoring
      "thermal_zone"       # Temperature monitoring
    ];
  };

  # === Fonts for Productivity ===
  fonts.packages = with pkgs; [
    # Professional fonts
    source-serif-pro
    source-sans-pro
    source-code-pro

    # Programming fonts
    fira-code
    fira-code-symbols
    jetbrains-mono

    # System fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    # Microsoft fonts for compatibility
    corefonts
    vistafonts

    # Icon fonts
    font-awesome
    material-design-icons
  ];

  # === Framework 12 Specific Aliases ===
  environment.shellAliases = {
    # Power management
    battery-status = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
    power-profile = "cat /sys/firmware/acpi/platform_profile";
    thermal-status = "cat /proc/acpi/ibm/thermal";

    # Hardware info
    framework-info = "sudo dmidecode | grep -A 5 'System Information'";
    expansion-cards = "lsusb && echo '---' && lspci";

    # Display management
    display-reset = "autorandr --change";
    hidpi-toggle = "gsettings set org.gnome.desktop.interface scaling-factor 1.0";

    # Performance
    performance-mode = "sudo cpupower frequency-set -g performance";
    powersave-mode = "sudo cpupower frequency-set -g powersave";

    # System maintenance
    cleanup-system = "sudo nix-collect-garbage -d && docker system prune -f";
    update-firmware = "sudo fwupdmgr refresh && sudo fwupdmgr update";

    # QRY Framework methodology
    framework-query = "echo 'How is the Framework 12 performing today?'";
    framework-refine = "echo 'What Framework settings need optimization?'";
    framework-yield = "echo 'What did we learn about Framework usage?'";
  };

  # === Systemd User Services ===
  systemd.user.services.qry-framework-monitor = {
    description = "QRY Framework 12 Monitoring";
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = pkgs.writeShellScript "framework-monitor" ''
        # Monitor Framework 12 specific metrics
        while true; do
          # Log battery status
          echo "$(date): Battery: $(cat /sys/class/power_supply/BAT0/capacity)%" >> /home/qry/.local/share/qry/framework-monitor.log

          # Log thermal status
          echo "$(date): Thermal: $(cat /sys/class/thermal/thermal_zone0/temp)" >> /home/qry/.local/share/qry/framework-monitor.log

          # Sleep for 5 minutes
          sleep 300
        done
      '';
      Restart = "always";
    };
  };

  # === Production Documentation ===
  environment.etc."qry/framework12-info".text = ''
    QRY Framework 12 Production Environment
    ======================================

    Hardware: Framework Laptop 12
    CPU: Intel i5-1334U (13th gen)
    RAM: 48GB DDR5-5600
    Storage: 2TB NVMe + 1TB expansion

    Optimizations:
    - Power management tuned for laptop use
    - HiDPI display scaling configured
    - Framework-specific kernel modules loaded
    - Expansion card support enabled
    - Battery charging thresholds set

    Monitoring:
    - Battery status: battery-status
    - Thermal monitoring: thermal-status
    - Performance mode: performance-mode / powersave-mode

    Maintenance:
    - Daily backups at 2 AM (AC power required)
    - Automatic firmware updates enabled
    - System cleanup: cleanup-system

    Support:
    - Framework community: https://community.frame.work/
    - NixOS Framework guide: https://nixos.wiki/wiki/Framework_Laptop
  '';

  # === State Version ===
  system.stateVersion = "24.05";
}
