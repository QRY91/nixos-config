# QRY Framework 12 Hardware Optimization Module
# Framework laptop specific configurations and optimizations

{ config, lib, pkgs, inputs, ... }:

{
  # === Framework 12 Hardware Identification ===
  # This module should only be imported for Framework laptops

  # === Kernel Configuration ===
  boot = {
    # Latest kernel for Framework support
    kernelPackages = pkgs.linuxPackages_latest;

    # Framework 12 specific kernel parameters
    kernelParams = [
      # Power management
      "mem_sleep_default=deep"          # Better suspend/resume
      "intel_pstate=active"             # Intel P-state driver
      "intel_idle.max_cstate=2"         # Prevent deep sleep issues

      # Graphics optimizations
      "i915.enable_psr=1"               # Panel self refresh
      "i915.enable_fbc=1"               # Framebuffer compression
      "i915.enable_guc=2"               # GuC firmware loading
      "i915.enable_dc=1"                # Display power saving

      # Audio optimizations
      "snd_hda_intel.power_save=1"      # Audio power saving

      # USB power management
      "usbcore.autosuspend=1"           # USB autosuspend

      # Framework expansion card support
      "pcie_aspm=force"                 # PCIe power management

      # Security vs performance balance
      "mitigations=auto"                # Keep some security mitigations

      # Reduce boot verbosity
      "quiet"
      "splash"
    ];

    # Framework specific kernel modules
    kernelModules = [
      "framework_laptop"                # Framework laptop support
      "cros_ec"                         # ChromeOS embedded controller
      "cros_ec_lpcs"                    # EC communication
      "uvcvideo"                        # Camera support
      "btusb"                           # Bluetooth support
      "iwlwifi"                         # Intel WiFi
      "snd_hda_intel"                   # Audio support
      "i2c_hid_acpi"                    # Touchpad support
      "hid_sensor_hub"                  # Sensor support
    ];

    # Blacklist problematic modules
    blacklistedKernelModules = [
      "nouveau"                         # Use Intel graphics only
      "nvidia"                          # Framework 12 uses Intel graphics
    ];

    # Firmware loading optimization
    initrd.availableKernelModules = [
      "xhci_pci"                        # USB 3.0 support
      "thunderbolt"                     # Thunderbolt support
      "nvme"                            # NVMe storage
      "usb_storage"                     # USB storage
      "sd_mod"                          # SD card support
    ];
  };

  # === Framework Hardware Support ===
  hardware = {
    # Enable all firmware
    enableAllFirmware = true;
    enableRedistributableFirmware = true;

    # Intel CPU microcode updates
    cpu.intel.updateMicrocode = true;

    # Framework uses Intel integrated graphics
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver              # VAAPI driver for Intel
        intel-compute-runtime           # OpenCL support
        vaapiIntel                      # VA-API support
        libvdpau-va-gl                  # VDPAU to VA-API bridge
        mesa.drivers                    # Mesa drivers
      ];

      extraPackages32 = with pkgs.pkgsi686Linux; [
        intel-media-driver
        vaapiIntel
        mesa.drivers
      ];
    };

    # Bluetooth configuration
    bluetooth = {
      enable = true;
      powerOnBoot = true;

      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;              # Enable experimental features
          FastConnectable = true;
          Privacy = "device";
        };

        Policy = {
          AutoEnable = true;
        };
      };
    };

    # Framework firmware support
    firmware = with pkgs; [
      linux-firmware                   # General firmware
      intel-vaapi-driver               # Intel graphics firmware
    ];
  };

  # === Power Management ===
  powerManagement = {
    enable = true;
    cpuFreqGovernor = lib.mkDefault "schedutil";  # Modern scheduler-based governor
    powertop.enable = true;
  };

  # TLP for advanced power management
  services.tlp = {
    enable = true;
    settings = {
      # CPU scaling governors
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # Energy performance preferences
      CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      # CPU boost settings
      CPU_BOOST_ON_AC = 1;
      CPU_BOOST_ON_BAT = 0;

      # Intel P-state preferences
      CPU_SCALING_MIN_FREQ_ON_AC = 400000;
      CPU_SCALING_MAX_FREQ_ON_AC = 4800000;
      CPU_SCALING_MIN_FREQ_ON_BAT = 400000;
      CPU_SCALING_MAX_FREQ_ON_BAT = 2400000;

      # Turbo boost
      CPU_HWP_DYN_BOOST_ON_AC = 1;
      CPU_HWP_DYN_BOOST_ON_BAT = 0;

      # Platform profiles
      PLATFORM_PROFILE_ON_AC = "performance";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      # WiFi power saving
      WIFI_PWR_ON_AC = "off";
      WIFI_PWR_ON_BAT = "on";

      # Sound power saving
      SOUND_POWER_SAVE_ON_AC = 0;
      SOUND_POWER_SAVE_ON_BAT = 1;

      # Runtime power management
      RUNTIME_PM_ON_AC = "on";
      RUNTIME_PM_ON_BAT = "auto";

      # USB autosuspend
      USB_AUTOSUSPEND = 1;
      USB_BLACKLIST_BTUSB = 0;
      USB_BLACKLIST_PHONE = 0;
      USB_BLACKLIST_PRINTER = 1;
      USB_BLACKLIST_WWAN = 0;

      # PCIe ASPM
      PCIE_ASPM_ON_AC = "default";
      PCIE_ASPM_ON_BAT = "powersupersave";

      # Battery charge thresholds (Framework specific)
      START_CHARGE_THRESH_BAT0 = 75;
      STOP_CHARGE_THRESH_BAT0 = 80;

      # Disk settings
      DISK_IDLE_SECS_ON_AC = 0;
      DISK_IDLE_SECS_ON_BAT = 2;
      MAX_LOST_WORK_SECS_ON_AC = 15;
      MAX_LOST_WORK_SECS_ON_BAT = 60;

      # AHCI link power management
      AHCI_RUNTIME_PM_ON_AC = "on";
      AHCI_RUNTIME_PM_ON_BAT = "auto";
      AHCI_RUNTIME_PM_TIMEOUT = 15;

      # SATA aggressive link power management
      SATA_LINKPWR_ON_AC = "med_power_with_dipm";
      SATA_LINKPWR_ON_BAT = "min_power";
    };
  };

  # CPU frequency scaling is configured in the main powerManagement block above

  # Thermal management
  services.thermald.enable = true;

  # === Display Configuration ===
  services.xserver = {
    # HiDPI configuration for Framework's high-resolution display
    dpi = 180;

    # Monitor configuration
    monitorSection = ''
      DisplaySize 294 166   # Framework 13.5" display dimensions in mm
    '';
  };

  # HiDPI environment variables
  environment.variables = {
    # Qt scaling
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_SCALE_FACTOR = "1.25";
    QT_SCREEN_SCALE_FACTORS = "1.25";

    # GTK scaling
    GDK_SCALE = "1.25";
    GDK_DPI_SCALE = "1.0";

    # Electron apps scaling
    ELECTRON_FORCE_IS_PACKAGED = "1";
  };

  # === Input Devices ===
  services.libinput = {
    enable = true;

    # Touchpad configuration
    touchpad = {
      naturalScrolling = true;
      tapping = true;
      clickMethod = "clickfinger";
      accelProfile = "adaptive";
      accelSpeed = "0.3";
      disableWhileTyping = true;
      middleEmulation = true;
      scrollMethod = "twofinger";
      horizontalScrolling = true;
    };


  };

  # === Framework Specific Services ===
  services = {
    # Firmware updates
    fwupd = {
      enable = true;
      extraRemotes = [ "lvfs-testing" ];  # Framework firmware updates
    };

    # Location services for automatic timezone
    geoclue2.enable = true;

    # Fingerprint reader support (Framework 13 has optional fingerprint module)
    fprintd.enable = true;

    # Framework expansion card management
    udev.extraRules = ''
      # Framework expansion card rules
      SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", ATTRS{idProduct}=="0001", MODE="0664", GROUP="users"

      # Framework HDMI expansion card
      SUBSYSTEM=="drm", KERNEL=="card[0-9]*", ATTRS{vendor}=="0x8086", ATTRS{device}=="0xa7a0", TAG+="seat", TAG+="master-of-seat"

      # Framework USB-C expansion cards
      SUBSYSTEM=="usb", ATTRS{idVendor}=="32ac", MODE="0664", GROUP="users"

      # Framework storage expansion cards
      SUBSYSTEM=="block", ATTRS{vendor}=="Framework", MODE="0664", GROUP="users"
    '';

    # Power button handling
    logind = {
      powerKey = "suspend";
      powerKeyLongPress = "poweroff";
      lidSwitch = "suspend";
      lidSwitchExternalPower = "lock";
      handleHibernateKey = "hibernate";
    };

    # Automatic screen brightness
    clight = {
      enable = true;
      settings = {
        verbose = true;
        backlight = {
          disabled = false;
          restore_on_exit = true;
          no_smooth_transition = false;
          trans_step = 0.05;
          trans_timeout = 30;
        };
        sensor = {
          devname = "iio:device0";  # Framework ambient light sensor
        };
      };
    };
  };

  # === Networking Optimizations ===
  networking = {
    networkmanager = {
      enable = true;
      wifi = {
        powersave = true;
        scanRandMacAddress = true;
      };
      ethernet.macAddress = "preserve";
    };

    # Disable wpa_supplicant (use NetworkManager instead)
    wireless.enable = false;
  };

  # === Framework Specific Packages ===
  environment.systemPackages = with pkgs; [
    # Framework utilities
    fw-ectool                         # Framework embedded controller tool

    # Power management tools
    powertop                          # Power consumption analyzer
    acpi                              # ACPI utilities
    lm_sensors                        # Hardware monitoring
    psensor                           # Temperature monitoring

    # Display utilities
    ddcutil                           # Display control
    autorandr                         # Display profile management

    # Battery utilities
    upower                            # Power management interface

    # Hardware information
    dmidecode                         # Hardware information
    lshw                              # Hardware listing
    hwinfo                            # Hardware detection
    inxi                              # System information

    # Expansion card management
    lsusb                             # USB device listing
    lspci                             # PCI device listing

    # Firmware tools
    fwupd                             # Firmware update daemon

    # Bluetooth tools
    bluez                             # Bluetooth stack
    bluez-tools                       # Bluetooth utilities

    # Network tools
    iw                                # Wireless tools
    wireless-tools                    # WiFi utilities

    # Performance monitoring
    intel-gpu-tools                   # Intel GPU utilities
    mesa-demos                        # OpenGL demos and tests

    # System testing
    stress                            # System stress testing
    memtester                         # Memory testing
    hdparm                            # Hard disk parameter utility
    smartmontools                     # Drive health monitoring
  ];

  # === System Optimization ===
  boot.kernel.sysctl = {
    # Memory management for laptops
    "vm.dirty_writeback_centisecs" = 6000;    # Reduce disk writes
    "vm.dirty_expire_centisecs" = 6000;       # Reduce disk writes
    "vm.dirty_ratio" = 15;                    # Memory vs disk balance
    "vm.dirty_background_ratio" = 5;          # Background writeback
    "vm.swappiness" = 10;                     # Prefer RAM over swap

    # Network optimizations
    "net.core.rmem_default" = 262144;
    "net.core.rmem_max" = 16777216;
    "net.core.wmem_default" = 262144;
    "net.core.wmem_max" = 16777216;

    # Framework specific optimizations
    "dev.i915.perf_stream_paranoid" = 0;      # Intel GPU performance
    "kernel.nmi_watchdog" = 0;                # Disable NMI watchdog for power saving
  };

  # === Framework Environment Variables ===
  environment.sessionVariables = {
    # Framework identification
    QRY_HARDWARE = "framework12";
    QRY_LAPTOP = "true";

    # Power management
    QRY_POWER_PROFILE = "laptop";

    # Display configuration
    QRY_HIDPI = "true";
    QRY_SCALING = "1.25";
  };

  # === Framework Specific Aliases ===
  environment.shellAliases = {
    # Framework hardware information
    framework-info = "sudo dmidecode | grep -A 10 'System Information'";
    framework-battery = "upower -i /org/freedesktop/UPower/devices/battery_BAT0";
    framework-thermal = "cat /sys/class/thermal/thermal_zone*/temp";
    framework-expansion = "lsusb | grep -i framework && lspci | grep -i framework";

    # Power management
    power-status = "tlp-stat -s";
    power-ac = "sudo tlp ac";
    power-battery = "sudo tlp bat";

    # Display management
    display-info = "xrandr --listmonitors";
    brightness-up = "brightnessctl set +10%";
    brightness-down = "brightnessctl set 10%-";

    # Hardware monitoring
    temps = "sensors";
    gpu-info = "intel_gpu_top";
    wifi-info = "iw dev wlan0 info";

    # Firmware management
    firmware-check = "sudo fwupdmgr get-devices";
    firmware-update = "sudo fwupdmgr refresh && sudo fwupdmgr update";

    # System optimization
    optimize-battery = "sudo powertop --auto-tune";
    check-power = "sudo powertop";
  };

  # === Framework Boot Optimization ===
  boot.loader.systemd-boot.consoleMode = "auto";  # Proper console on HiDPI
  boot.plymouth.enable = true;                     # Smooth boot experience

  # === Framework Backup Considerations ===
  # When configuring borgbackup, consider excluding these Framework-specific paths:
  # - /var/lib/fwupd/pending     # Firmware update cache
  # - /var/log/fwupd             # Firmware logs
  #
  # Example borgbackup exclude configuration:
  # services.borgbackup.jobs.mybackup.exclude = [
  #   "/var/lib/fwupd/pending"
  #   "/var/log/fwupd"
  # ];

  # === Framework Documentation ===
  environment.etc."qry/framework-optimization".text = ''
    QRY Framework 12 Hardware Optimizations
    =======================================

    This configuration optimizes NixOS for the Framework Laptop 12.

    Key Optimizations:
    - Intel 13th gen CPU power management
    - Integrated graphics acceleration
    - HiDPI display scaling (1.25x)
    - Expansion card support
    - Battery charge thresholds (75-80%)
    - Thermal management
    - WiFi 6E optimization
    - Bluetooth LE support

    Hardware Features:
    - CPU: Intel i5-1334U (13th gen)
    - Graphics: Intel Iris Xe
    - Display: 13.5" 2256x1504 (3:2 aspect)
    - WiFi: Intel AX210 (WiFi 6E)
    - Bluetooth: 5.3
    - Expansion cards: USB-C, HDMI, Storage, etc.

    Power Management:
    - AC: Performance mode, turbo enabled
    - Battery: Power save mode, turbo disabled
    - Sleep: Deep sleep (S3) configured
    - Battery: 75-80% charge threshold

    Monitoring Commands:
    - framework-info: Hardware information
    - framework-battery: Battery status
    - framework-thermal: Temperature monitoring
    - power-status: Power management status

    Troubleshooting:
    - If expansion cards not detected: check framework-expansion
    - If battery drains fast: run optimize-battery
    - If display scaling wrong: adjust QRY_SCALING variable
    - If WiFi issues: check wifi-info and restart NetworkManager

    Framework Resources:
    - Framework Community: https://community.frame.work/
    - Framework Guides: https://guides.frame.work/
    - Linux Support: https://github.com/FrameworkComputer/linux-docs
  '';

  # === QRY Framework Philosophy Integration ===
  # This module embodies:
  # - Local-first hardware: All optimizations work offline
  # - Systematic optimization: Every setting documented and purposeful
  # - Anti-fragile laptop: Robust power management and thermal control
  # - Junkyard engineering: Hackable, understandable hardware interface
  # - Professional mobile computing: Optimized for productivity anywhere
}
