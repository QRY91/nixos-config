# QRY Gaming Environment
# Steam, performance optimization, and gaming utilities

{ config, lib, pkgs, inputs, ... }:

{
  # === Gaming Applications ===
  environment.systemPackages = with pkgs; [
    # === Steam and Gaming Platforms ===
    steam               # Primary gaming platform
    steam-run           # Run non-Steam games
    lutris              # Gaming manager
    heroic              # Epic Games launcher
    bottles             # Windows app runner

    # === Gaming Utilities ===
    mangohud            # Performance overlay
    goverlay            # MangoHud configurator
    gamemode            # Gaming performance optimizer
    gamescope           # Gaming compositor

    # === Emulation ===
    retroarch           # Multi-emulator
    pcsx2               # PlayStation 2 emulator
    dolphin-emu         # GameCube/Wii emulator
    cemu                # Wii U emulator

    # === Game Development Testing ===
    godot4              # For testing indie games

    # === Controller Support ===
    linuxConsoleTools   # Controller utilities
    jstest-gtk          # Controller testing
    antimicrox          # Controller to keyboard mapping

    # === Gaming Hardware ===
    openrgb             # RGB control
    piper               # Gaming mouse configuration

    # === Performance Monitoring ===
    glxinfo             # OpenGL info
    vulkan-tools        # Vulkan utilities
    mesa-demos          # OpenGL demos

    # === Network Gaming ===
    teamspeak_client    # Voice communication
    discord             # Gaming communication

    # === Gaming Productivity ===
    obs-studio          # Game streaming/recording

    # === Wine and Compatibility ===
    wineWowPackages.staging  # Wine staging
    winetricks          # Wine helper
    protontricks        # Proton helper

    # === Gaming File Management ===
    unrar               # Extract game archives
    p7zip               # Archive support

    # === Performance Testing ===
    unigine-valley      # GPU benchmark
    glmark2             # OpenGL benchmark

    # === Gaming Scripts and Utilities ===
    # Note: Custom gaming scripts will be added here
  ];

  # === Steam Configuration ===
  programs.steam = {
    enable = true;

    # Enable Steam Remote Play
    remotePlay.openFirewall = true;

    # Enable Steam Local Network Game Transfers
    localNetworkGameTransfers.openFirewall = true;

    # Enable dedicated server support
    dedicatedServer.openFirewall = true;

    # Additional Steam packages
    extraCompatPackages = with pkgs; [
      proton-ge-bin       # GE-Proton for better compatibility
    ];

    # Steam Gamescope session for console-like experience
    gamescopeSession.enable = true;
  };

  # === GameMode Configuration ===
  programs.gamemode = {
    enable = true;

    settings = {
      general = {
        # Renice game processes
        renice = 10;

        # Disable desktop compositor during gaming
        desktopfile = "gamemode";

        # Enable soft real-time scheduling
        softrealtime = "auto";

        # Inhibit screen saver
        inhibit_screensaver = 1;
      };

      # GPU optimizations
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;

        # AMD GPU optimizations
        amd_performance_level = "high";

        # NVIDIA GPU optimizations (uncomment if using NVIDIA)
        # nvidia_powermizer_mode = 1;
      };

      # CPU optimizations
      cpu = {
        park_cores = "no";
        pin_cores = "no";
      };

      # Custom scripts
      custom = {
        start = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations activated' -i applications-games";
        end = "${pkgs.libnotify}/bin/notify-send 'GameMode' 'Optimizations deactivated' -i applications-games";
      };
    };
  };

  # === Graphics Optimization ===
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      # Intel graphics
      intel-media-driver
      vaapiIntel

      # AMD graphics
      amdvlk

      # General
      mesa
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];

    extraPackages32 = with pkgs.pkgsi686Linux; [
      # 32-bit graphics support for older games
      intel-media-driver
      vaapiIntel
      amdvlk
      mesa
    ];
  };

  # === Audio Optimization for Gaming ===
  services.pipewire = {
    extraConfig.pipewire = {
      "99-qry-gaming" = {
        "context.properties" = {
          # Lower latency for gaming
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 128;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 1024;
        };
      };
    };
  };

  # === Controller Support ===
  # Enable Xbox controller support
  hardware.xone.enable = true;

  # PlayStation controller support
  hardware.steam-hardware.enable = true;

  # Generic controller support
  services.joycond.enable = true;  # Nintendo Pro Controller

  # === Network Optimization ===
  # Gaming network optimizations
  boot.kernel.sysctl = {
    # Network performance
    "net.core.rmem_default" = 262144;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 262144;
    "net.core.wmem_max" = 16777216;

    # Reduce network latency
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_congestion_control" = "bbr";

    # Gaming-specific network settings
    "net.core.netdev_max_backlog" = 5000;
    "net.ipv4.tcp_mtu_probing" = 1;
  };

  # === Gaming Performance Optimization ===
  # CPU frequency scaling for gaming
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # Memory management for gaming
  boot.kernel.sysctl = {
    # Memory optimization
    "vm.dirty_ratio" = 3;
    "vm.dirty_background_ratio" = 2;
    "vm.swappiness" = 10;
    "vm.vfs_cache_pressure" = 50;

    # Gaming-specific memory settings
    "vm.min_free_kbytes" = 65536;
    "kernel.sched_autogroup_enabled" = 0;
  };

  # === Kernel Optimization ===
  boot.kernelParams = [
    # Gaming optimizations
    "mitigations=off"           # Disable CPU mitigations for performance
    "intel_idle.max_cstate=1"   # Reduce CPU idle states
    "processor.max_cstate=1"    # Reduce CPU idle states
    "idle=poll"                 # Aggressive CPU scheduling

    # Memory optimizations
    "transparent_hugepage=never"

    # PCI optimizations
    "pcie_aspm=off"

    # Real-time optimizations
    "preempt=full"
    "threadirqs"
  ];

  # === Gaming Environment Variables ===
  environment.variables = {
    # Steam optimizations
    STEAM_FORCE_DESKTOPUI_SCALING = "1";

    # Gaming performance
    __GL_THREADED_OPTIMIZATIONS = "1";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_PATH = "/tmp/nvidia-shader-cache";

    # Proton optimizations
    PROTON_ENABLE_NVAPI = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";

    # Gaming workspace
    QRY_GAMING_PATH = "$HOME/gaming";
    QRY_GAMES_PATH = "$HOME/gaming/games";
    QRY_SAVES_PATH = "$HOME/gaming/saves";
    QRY_SCREENSHOTS_PATH = "$HOME/gaming/screenshots";
  };

  # === Gaming Workspace Setup ===
  environment.interactiveShellInit = ''
    # QRY Gaming Environment Setup
    export QRY_GAMING_PATH="$HOME/gaming"
    export QRY_GAMES_PATH="$QRY_GAMING_PATH/games"
    export QRY_SAVES_PATH="$QRY_GAMING_PATH/saves"
    export QRY_SCREENSHOTS_PATH="$QRY_GAMING_PATH/screenshots"
    export QRY_CONFIGS_PATH="$QRY_GAMING_PATH/configs"

    # Create gaming directories
    mkdir -p "$QRY_GAMES_PATH"/{steam,epic,gog,indie}
    mkdir -p "$QRY_SAVES_PATH"/{steam,epic,gog,indie}
    mkdir -p "$QRY_SCREENSHOTS_PATH"
    mkdir -p "$QRY_CONFIGS_PATH"

    # Gaming aliases
    alias steam-qry="steam -no-cef-sandbox"
    alias steam-logs="tail -f ~/.steam/logs/content_log.txt"
    alias proton-logs="tail -f ~/.steam/steam/logs/compatmanager.log"

    # Performance monitoring
    alias fps="mangohud"
    alias gpu-temp="watch -n 1 nvidia-smi"  # Adjust for your GPU
    alias cpu-temp="watch -n 1 sensors"

    # Gaming utilities
    alias screenshot="flameshot gui"
    alias record-game="obs --minimize-to-tray --startrecording"
    alias gamemode-status="gamemode --status"

    # Game management
    alias backup-saves="rsync -av $QRY_SAVES_PATH $HOME/backups/gaming-saves-$(date +%Y%m%d)"
    alias clean-shader-cache="rm -rf ~/.cache/mesa_shader_cache ~/.cache/nvidia/GLCache"

    # Controller testing
    alias test-controller="jstest-gtk"
    alias controller-config="antimicrox"

    # Wine/Proton utilities
    alias wine-config="winecfg"
    alias proton-config="protontricks"

    # Gaming network
    alias gaming-network="sudo tc qdisc add dev eth0 root fq"  # Adjust interface

    # QRY gaming methodology
    alias game-session-start="echo 'Starting gaming session at $(date)' >> $QRY_GAMING_PATH/session.log"
    alias game-session-end="echo 'Ending gaming session at $(date)' >> $QRY_GAMING_PATH/session.log"
    alias gaming-stats="cat $QRY_GAMING_PATH/session.log | tail -20"
  '';

  # === Gaming Services ===
  # Enable game-specific services
  services.ratbagd.enable = true;  # For Piper mouse configuration

  # === Gaming Firewall ===
  networking.firewall = {
    allowedTCPPorts = [
      27015  # Steam
      27036  # Steam
      27037  # Steam
    ];

    allowedUDPPorts = [
      27015  # Steam
      27031  # Steam
      27036  # Steam
    ];

    allowedTCPPortRanges = [
      { from = 27014; to = 27050; }  # Steam
    ];

    allowedUDPPortRanges = [
      { from = 27000; to = 27100; }  # Steam
    ];
  };

  # === Gaming Fonts ===
  fonts.packages = with pkgs; [
    # Gaming fonts
    source-code-pro
    dejavu_fonts
    liberation_ttf

    # Console fonts
    terminus_font

    # Icon fonts for gaming UIs
    font-awesome
  ];

  # === Gaming Power Management ===
  # Disable power saving during gaming
  services.tlp.enable = lib.mkForce false;  # Disable laptop power management

  # === Gaming Kernel Modules ===
  boot.kernelModules = [
    "uinput"           # For controller emulation
    "v4l2loopback"     # For virtual cameras (streaming)
  ];

  # === Gaming File Systems ===
  # Enable support for gaming file systems
  boot.supportedFilesystems = [ "ntfs" ];  # For Windows game drives

  # === Gaming Backup Strategy ===
  services.borgbackup.jobs.gaming = {
    paths = [
      "/home/qry/gaming/saves"
      "/home/qry/gaming/configs"
      "/home/qry/gaming/screenshots"
    ];
    repo = "/home/qry/backups/gaming";
    compression = "auto,zstd";
    startAt = "daily";

    preHook = ''
      echo "Starting gaming backup at $(date)"
    '';

    postHook = ''
      echo "Gaming backup completed at $(date)"
    '';
  };

  # === Gaming Security ===
  # Enable sandboxing for gaming applications
  programs.firejail.enable = true;

  # === Gaming Monitoring ===
  # Enable system monitoring for gaming performance
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [ "systemd" "cpu" "meminfo" "diskstats" "filesystem" ];
  };

  # === QRY Gaming Philosophy Integration ===
  # This module embodies:
  # - Systematic gaming: Organized game library and performance monitoring
  # - Anti-fragile gaming: Backup strategies and rollback capabilities
  # - Local-first gaming: Offline gaming capabilities and local storage
  # - Junkyard engineering: Hackable gaming environment with monitoring
  # - Performance optimization: Maximum FPS and minimum latency
  # - Professional gaming: Streaming and recording capabilities
}
