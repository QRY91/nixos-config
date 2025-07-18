# QRY NixOS Configuration

**Systematic Engineering Environment for Local-First AI Development**

This repository contains a complete NixOS configuration implementing the QRY methodology: **Query, Refine, Yield**. Built for systematic engineering with local-first AI tools, creative applications, and anti-fragile computing principles.

## Philosophy

> *"Nothing is precious. Everything is systematic. Local-first independence through junkyard engineering."*

This configuration embodies:
- **Local-first computing**: All tools work offline, no cloud dependencies
- **Anti-fragile systems**: Easy rollbacks, safe experimentation
- **Systematic methodology**: Every decision documented and reproducible
- **Junkyard engineering**: Hackable, transparent, understandable tools

## Quick Start

### Testing Phase (Debbie)
```bash
# Clone the configuration
git clone git@github.com:QRY91/nixos-config.git
cd nixos-config

# Deploy to test machine
sudo nixos-rebuild switch --flake .#debbie
```

### Production Deployment (Framework 12)
```bash
# Deploy to Framework 12
sudo nixos-rebuild switch --flake .#framework12
```

## What You Get

### 🛠️ Development Environment
- **Languages**: Go, Python, Node.js, Rust
- **Editors**: Neovim with LSP, VS Code
- **Terminal**: Zellij multiplexer, Starship prompt
- **AI Tools**: Ollama (local LLM), Aider (AI pair programming)
- **Containers**: Docker, Podman

### 🎨 Creative Suite
- **3D Modeling**: Blender with GPU acceleration
- **Game Development**: Godot 4, Pico-8
- **Audio Production**: Reaper with Musnix (real-time audio)
- **Graphics**: GIMP, Inkscape, Krita

### 🎮 Gaming Platform
- **Steam**: With Proton, GameMode optimization
- **Performance**: GPU acceleration, real-time scheduling
- **Controllers**: Xbox, PlayStation, Nintendo Pro support

### 🤖 AI Development Stack
- **Local LLMs**: Ollama serving models offline
- **ML/AI**: PyTorch, Transformers, Jupyter Lab
- **Data Science**: Pandas, NumPy, Matplotlib
- **Privacy-first**: No data leaves your machine

## Repository Structure

```
nixos-config/
├── flake.nix                    # Main flake with host configurations
├── home.nix                     # Home-manager user configuration
├── INSTALL.md                   # Detailed installation guide
├── README.md                    # This file
├── modules/
│   ├── common.nix              # Shared system configuration
│   ├── development.nix         # Programming languages and tools
│   ├── creative.nix            # Creative applications and pro audio
│   ├── gaming.nix              # Gaming and performance optimization
│   ├── ai-tools.nix           # Local AI and ML stack
│   └── framework.nix           # Framework laptop optimizations
└── hosts/
    ├── debbie/                 # Test desktop configuration
    │   └── configuration.nix
    └── framework12/            # Framework 12 production config
        └── configuration.nix
```

## Host Configurations

### Debbie (Test Desktop)
- **Purpose**: Testing and development of Framework 12 configuration
- **Environment**: Full GNOME desktop for compatibility testing
- **Use Case**: Validate all applications before Framework deployment

### Framework 12 (Production Laptop)
- **Hardware**: Framework Laptop 12, Intel i5-1334U, 48GB RAM
- **Optimizations**: HiDPI scaling, power management, expansion cards
- **Use Case**: Mobile development and AI work

## QRY Methodology Integration

### Query Phase
```bash
# What are we building?
qry-status                    # Environment overview
framework-info               # Hardware information
ai-status                    # AI stack status
```

### Refine Phase
```bash
# Systematic improvements
nix flake update             # Update dependencies
sudo nixos-rebuild test      # Test changes safely
git commit -m "refine: ..."  # Document improvements
```

### Yield Phase
```bash
# Share learnings
git push origin main         # Version control knowledge
backup-system               # Preserve working state
document-changes            # Capture insights
```

## Key Features

### 🔒 Security & Privacy
- Local-first AI (no cloud API calls)
- Firewall configured
- SSH hardened
- Offline-capable workflow

### ⚡ Performance Optimization
- Framework 12 power management
- Gaming performance tuning
- Real-time audio (Musnix)
- SSD optimization

### 🔄 System Management
- Declarative configuration
- Atomic upgrades/rollbacks
- Automated backups
- Generation management

### 🎛️ Hardware Support
- Framework expansion cards
- Audio interfaces (professional)
- Gaming controllers
- External displays (HiDPI)

## Installation

See [INSTALL.md](INSTALL.md) for detailed installation instructions.

**Quick Installation**:
1. Boot NixOS installer
2. Clone this repository
3. Run `sudo nixos-rebuild switch --flake .#<hostname>`
4. Reboot and enjoy systematic computing

## Applications Included

### Development
- **Go**: Full toolchain with LSP
- **Python**: AI/ML stack with PyTorch
- **Node.js**: Modern JavaScript development
- **Rust**: Systems programming
- **Containers**: Docker, Podman

### Creative
- **Blender**: 3D modeling and animation
- **Godot 4**: Game engine
- **Reaper**: Digital audio workstation
- **GIMP/Inkscape**: Graphics editing
- **OBS Studio**: Streaming/recording

### Productivity
- **Firefox**: Web browser
- **Obsidian**: Knowledge management
- **LibreOffice**: Office suite
- **Signal**: Secure messaging

### AI & Data Science
- **Ollama**: Local LLM serving
- **Aider**: AI pair programming
- **Jupyter Lab**: Data science notebooks
- **PyTorch**: Deep learning framework

## Customization

### Adding New Applications
```nix
# In appropriate module file
environment.systemPackages = with pkgs; [
  your-new-package
];
```

### Creating New Hosts
```nix
# In flake.nix
nixosConfigurations.your-host = nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = { inherit inputs; };
  modules = commonModules ++ [
    ./hosts/your-host/configuration.nix
    ./hosts/your-host/hardware-configuration.nix
  ];
};
```

### User Environment Customization
Edit `home.nix` for user-specific configurations:
- Shell aliases and functions
- Editor configurations
- Development tool settings
- Personal applications

## Maintenance

### System Updates
```bash
# Update flake inputs
nix flake update

# Rebuild system
sudo nixos-rebuild switch --upgrade-all

# Clean old generations
sudo nix-collect-garbage -d
```

### Backup Strategy
```bash
# System configuration is in git
git push origin main

# User data backup
backup-system              # Automated via borgbackup

# Test restore procedures
test-restore               # Verify backup integrity
```

### Monitoring
```bash
# System health
systemctl status           # Service status
htop                      # Resource usage
journalctl -f             # System logs

# Hardware monitoring
framework-thermal         # Temperature monitoring
framework-battery         # Battery status
```

## Troubleshooting

### Boot Issues
```bash
# At GRUB menu, select previous generation
# Then rollback: sudo nixos-rebuild switch --rollback
```

### Application Issues
```bash
# Check if package exists
nix search nixpkgs package-name

# Test in temporary shell
nix-shell -p package-name

# Check service status
systemctl status service-name
```

### Performance Issues
```bash
# System resources
htop && iotop

# Clean up
sudo nix-collect-garbage -d
cleanup-system
```

## Contributing

This configuration follows systematic engineering principles:

1. **Query**: What problem does this solve?
2. **Refine**: How can we improve it systematically?
3. **Yield**: Document learnings for others

### Making Changes
1. Test changes on Debbie first
2. Document the reasoning
3. Ensure reproducibility
4. Update documentation

## Resources

- **NixOS Manual**: https://nixos.org/manual/nixos/stable/
- **Home Manager**: https://github.com/nix-community/home-manager
- **Framework Laptop**: https://frame.work/
- **QRY Methodology**: Embedded in this configuration

## License

This configuration is released into the public domain (CC0). Knowledge wants to be free and combinable.

## Support

For issues specific to this configuration:
- Open an issue on GitHub
- Follow systematic debugging approaches
- Document solutions for others

---

*"The best system configuration is one you understand completely and can rebuild from scratch. The second best is one that documents every decision and teaches you how it works."*

**Status**: Production ready for systematic engineering
**Philosophy**: Local-first, anti-fragile, systematic
**Methodology**: Query, Refine, Yield

Built with 🔧 junkyard engineering principles and ❤️ for systematic computing.