# QRY Creative Environment
# Tools for game development, 3D modeling, audio production, and visual design

{ config, lib, pkgs, inputs, ... }:

{
  # === Creative Applications ===
  environment.systemPackages = with pkgs; [
    # === 3D Modeling and Animation ===
    blender             # Primary 3D suite
    freecad             # CAD modeling
    openscad            # Parametric CAD

    # === Game Development ===
    godot4              # Primary game engine
    unity-launcher      # Unity Hub
    pico8               # Fantasy console

    # Additional game dev tools
    tiled               # Tile map editor
    ldtk                # Level editor
    aseprite            # Pixel art editor

    # === Audio Production ===
    reaper              # Primary DAW
    audacity            # Audio editing
    tenacity            # Audacity fork

    # Audio plugins and synthesizers
    helm                # Synthesizer
    surge               # Synthesizer
    vital               # Synthesizer (if available)

    # Audio utilities
    jack2               # Professional audio
    qjackctl            # JACK control
    pavucontrol         # PulseAudio control
    helvum              # PipeWire patchbay
    easyeffects         # Audio effects

    # === Graphics and Design ===
    gimp                # Image editing
    inkscape            # Vector graphics
    krita               # Digital painting

    # Photography
    darktable           # RAW processor
    rawtherapee         # RAW processor

    # Screen capture
    flameshot           # Screenshots
    obs-studio          # Screen recording/streaming

    # === Video Editing ===
    kdenlive            # Primary video editor
    davinci-resolve     # Professional editing (if available)
    handbrake           # Video transcoding
    ffmpeg              # Video processing

    # === Font Management ===
    font-manager        # Font management

    # === Color Management ===
    displaycal          # Display calibration

    # === 3D Printing ===
    prusa-slicer        # 3D printing slicer
    cura                # Alternative slicer

    # === Creative Coding ===
    processing          # Creative coding
    openframeworks      # Creative coding framework

    # === CAD and Engineering ===
    kicad               # PCB design
    librecad            # 2D CAD

    # === Music Production Utilities ===
    guitarix            # Guitar amplifier
    hydrogen            # Drum machine
    lmms                # Music production

    # === Media Conversion ===
    imagemagick         # Image conversion
    sox                 # Audio conversion

    # === Creative Utilities ===
    colorpicker         # System color picker
    gcolor3             # Color picker

    # === Asset Management ===
    digikam             # Photo management

    # === Animation ===
    synfigstudio        # 2D animation
    pencil2d            # Traditional animation

    # === Audio Analysis ===
    spectrum-analyzer   # Audio spectrum analysis

    # === Creative Collaboration ===
    inkscape            # Vector graphics
    scribus             # Desktop publishing

    # === Game Asset Creation ===
    texture-synthesis   # Texture generation

    # === Audio Hardware Support ===
    alsa-utils          # ALSA utilities
    pulseaudio-ctl      # PulseAudio control

    # === Graphics Drivers ===
    mesa                # OpenGL implementation
    vulkan-tools        # Vulkan utilities

    # === Creative Scripting ===
    blender-with-packages # Blender with Python

    # === File Format Support ===
    # Video codecs
    x264
    x265
    libvpx

    # Audio codecs
    lame                # MP3 encoding
    flac                # FLAC support
    opus                # Opus codec

    # Image formats
    webp-pixbuf-loader  # WebP support

    # === Creative Asset Libraries ===
    # Note: These would be custom packages for asset management

    # === Performance Monitoring ===
    nvidia-system-monitor-qt  # GPU monitoring (if NVIDIA)

    # === Creative Cloud Alternatives ===
    # Note: Open source alternatives to Adobe Creative Suite

    # === Productivity for Creatives ===
    kalker              # Calculator
    units               # Unit conversion

    # === File Management for Assets ===
    thunar              # File manager with good thumbnail support

    # === Creative Backup ===
    git-annex           # Large file versioning

    # === Hardware Control ===
    solaar              # Logitech device management

    # === Display Management ===
    arandr              # Display configuration

    # === Creative Workflows ===
    # Note: Custom scripts and workflows will be added here
  ];

  # === Musnix Integration for Pro Audio ===
  imports = [ inputs.musnix.nixosModules.musnix ];

  musnix = {
    enable = true;

    # Real-time kernel for low-latency audio
    kernel = {
      realtime = true;
      packages = pkgs.linuxPackages_rt_latest;
    };

    # Audio optimization
    rtirq.enable = true;

    # User permissions for audio
    users = [ "qry" ];
  };

  # === Audio System Configuration ===
  # Already configured in common.nix, but we ensure specific settings
  services.pipewire = {
    extraConfig.pipewire = {
      "99-qry-audio" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 128;
          "default.clock.min-quantum" = 32;
          "default.clock.max-quantum" = 2048;
        };
      };
    };
  };

  # === Graphics and Display ===
  # Enable hardware acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;

    extraPackages = with pkgs; [
      intel-media-driver  # For Intel graphics
      vaapiIntel         # VA-API support
      vaapiVdpau         # VDPAU support
      libvdpau-va-gl     # VDPAU to VA-API
    ];
  };

  # === VST and Audio Plugin Environment ===
  environment.variables = {
    # VST plugin paths
    VST_PATH = "$HOME/.vst:$HOME/.nix-profile/lib/vst:/run/current-system/sw/lib/vst";
    VST3_PATH = "$HOME/.vst3:$HOME/.nix-profile/lib/vst3:/run/current-system/sw/lib/vst3";
    LV2_PATH = "$HOME/.lv2:$HOME/.nix-profile/lib/lv2:/run/current-system/sw/lib/lv2";
    LADSPA_PATH = "$HOME/.ladspa:$HOME/.nix-profile/lib/ladspa:/run/current-system/sw/lib/ladspa";
    DSSI_PATH = "$HOME/.dssi:$HOME/.nix-profile/lib/dssi:/run/current-system/sw/lib/dssi";

    # Blender configuration
    BLENDER_USER_CONFIG = "$HOME/.config/blender";
    BLENDER_USER_SCRIPTS = "$HOME/.config/blender/scripts";

    # Godot configuration
    GODOT_USER_DATA_DIR = "$HOME/.local/share/godot";

    # Reaper configuration
    REAPER_USER_CONFIG = "$HOME/.config/REAPER";

    # Creative workspace
    QRY_CREATIVE_PATH = "$HOME/creative";
    QRY_ASSETS_PATH = "$HOME/creative/assets";
    QRY_PROJECTS_PATH = "$HOME/creative/projects";
  };

  # === Creative Workspace Setup ===
  environment.interactiveShellInit = ''
    # QRY Creative Environment Setup
    export QRY_CREATIVE_PATH="$HOME/creative"
    export QRY_ASSETS_PATH="$QRY_CREATIVE_PATH/assets"
    export QRY_PROJECTS_PATH="$QRY_CREATIVE_PATH/projects"
    export QRY_BLENDER_PATH="$QRY_CREATIVE_PATH/blender"
    export QRY_GODOT_PATH="$QRY_CREATIVE_PATH/godot"
    export QRY_AUDIO_PATH="$QRY_CREATIVE_PATH/audio"

    # Create creative directories
    mkdir -p "$QRY_ASSETS_PATH"/{models,textures,audio,fonts,images}
    mkdir -p "$QRY_PROJECTS_PATH"/{blender,godot,audio,graphics}
    mkdir -p "$QRY_BLENDER_PATH"/{scripts,addons,presets}
    mkdir -p "$QRY_GODOT_PATH"/{projects,assets,scripts}
    mkdir -p "$QRY_AUDIO_PATH"/{samples,projects,plugins,presets}

    # Creative workflow aliases
    alias blender-qry="blender --python-console"
    alias godot-qry="godot4 --editor"
    alias reaper-qry="reaper -new"

    # Asset management aliases
    alias assets="cd $QRY_ASSETS_PATH"
    alias projects="cd $QRY_PROJECTS_PATH"
    alias creative="cd $QRY_CREATIVE_PATH"

    # Quick project creation
    alias new-blender="cd $QRY_PROJECTS_PATH/blender && blender --factory-startup"
    alias new-godot="cd $QRY_PROJECTS_PATH/godot && godot4 --editor"
    alias new-audio="cd $QRY_PROJECTS_PATH/audio && reaper -new"

    # Creative utilities
    alias screenshot="flameshot gui"
    alias record="obs --minimize-to-tray --startrecording"
    alias audio-info="pactl info"
    alias gpu-info="glxinfo | grep -E 'OpenGL vendor|OpenGL renderer'"

    # QRY creative methodology
    alias iterate="echo 'Create -> Review -> Refine -> Document'"
    alias backup-creative="rsync -av $QRY_CREATIVE_PATH $HOME/backups/creative-$(date +%Y%m%d)"
  '';

  # === Service Configuration for Creative Work ===

  # Enable JACK for professional audio (optional, can coexist with PipeWire)
  services.jack = {
    jackd.enable = false;  # We're using PipeWire's JACK implementation
    alsa.enable = false;
  };

  # === Font Configuration for Creative Work ===
  fonts.packages = with pkgs; [
    # Design fonts
    source-sans-pro
    source-serif-pro
    source-code-pro

    # Creative fonts
    font-awesome
    material-design-icons

    # Typography
    liberation_ttf
    dejavu_fonts
    ubuntu_font_family

    # Specialty fonts
    fira
    fira-code

    # Icon fonts
    nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" "Hack" ]; }
  ];

  # === Gaming Integration for Creative Work ===
  # Some creative tools benefit from gaming optimizations
  programs.gamemode.enable = true;

  # === File Associations for Creative Work ===
  xdg.mime = {
    enable = true;
    defaultApplications = {
      "image/png" = "gimp.desktop";
      "image/jpeg" = "gimp.desktop";
      "image/svg+xml" = "inkscape.desktop";
      "video/mp4" = "kdenlive.desktop";
      "audio/wav" = "reaper.desktop";
      "audio/flac" = "reaper.desktop";
      "model/gltf+json" = "blender.desktop";
      "application/x-blender" = "blender.desktop";
    };
  };

  # === Performance Optimization ===
  # CPU frequency scaling for creative workloads
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # Memory management for large creative files
  boot.kernel.sysctl = {
    "vm.dirty_ratio" = 15;
    "vm.dirty_background_ratio" = 5;
    "vm.swappiness" = 10;
  };

  # === Backup Strategy for Creative Work ===
  services.syncthing = {
    enable = true;
    user = "qry";
    dataDir = "/home/qry/syncthing";
    configDir = "/home/qry/.config/syncthing";
  };

  # === Security for Creative Assets ===
  # Enable AppArmor for creative applications
  security.apparmor.enable = true;

  # === QRY Creative Philosophy Integration ===
  # This module embodies:
  # - Systematic creativity: Organized workflows and asset management
  # - Anti-fragile creation: Version control and backup strategies
  # - Local-first creativity: All tools work offline
  # - Junkyard engineering: Modular, hackable creative pipeline
  # - Professional quality: Real-time audio and optimized graphics
}
