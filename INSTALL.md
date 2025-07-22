# QRY NixOS Installation Guide
## Framework 12 Direct Installation

**Philosophy**: Deploy systematically to Framework 12 with proven NixOS configuration.

---

## Framework 12 Installation

### Prerequisites

**What you need**:
- Framework 12 laptop
- USB stick (8GB+)
- Internet connection
- This configuration repo
- About 2-3 hours for full setup

**Important**: This will completely wipe the Framework 12. Make sure there's nothing precious on it.

### Step 1: Prepare Installation Media

```bash
# Download NixOS unstable ISO (Framework 12 compatibility)
wget https://channels.nixos.org/nixos-unstable/latest-nixos-minimal-x86_64-linux.iso

# Or use the graphical ISO for easier installation
wget https://channels.nixos.org/nixos-unstable/latest-nixos-gnome-x86_64-linux.iso

# Flash to USB (replace /dev/sdX with your USB device)
sudo dd if=latest-nixos-gnome-x86_64-linux.iso of=/dev/sdX bs=4M status=progress
```

### Step 2: Boot and Install Base System

1. **Boot from USB**
   - Insert USB into Framework 12
   - Boot from USB (F12 or power on with USB inserted)
   - Select "NixOS Live"

2. **Network Setup**
   ```bash
   # Connect to WiFi if needed
   sudo systemctl start wpa_supplicant
   wpa_cli
   > add_network
   > set_network 0 ssid "YourWiFiName"
   > set_network 0 psk "YourWiFiPassword"
   > enable_network 0
   > quit
   ```

3. **Partition Disk**
   ```bash
   # Check available disks
   lsblk
   
   # Partition the main drive (adjust /dev/sda as needed)
   sudo parted /dev/sda -- mklabel gpt
   sudo parted /dev/sda -- mkpart ESP fat32 1MiB 512MiB
   sudo parted /dev/sda -- set 1 esp on
   sudo parted /dev/sda -- mkpart primary 512MiB 100%
   
   # Format partitions
   sudo mkfs.fat -F 32 -n boot /dev/sda1
   sudo mkfs.ext4 -L nixos /dev/sda2
   
   # Mount filesystems
   sudo mount /dev/disk/by-label/nixos /mnt
   sudo mkdir -p /mnt/boot
   sudo mount /dev/disk/by-label/boot /mnt/boot
   ```

4. **Generate Initial Configuration**
   ```bash
   # Generate hardware config
   sudo nixos-generate-config --root /mnt
   
   # This creates:
   # /mnt/etc/nixos/configuration.nix
   # /mnt/etc/nixos/hardware-configuration.nix
   ```

5. **Install Base System**
   ```bash
   # Install with the generated config
   sudo nixos-install
   
   # Set root password when prompted
   # Reboot when done
   sudo reboot
   ```

### Step 3: Clone QRY Configuration

After rebooting into the base NixOS system:

```bash
# Login as root initially
# Create user first
useradd -m -G wheel qry
passwd qry

# Switch to qry user
su - qry

# Install git if not available
nix-shell -p git

# Clone the configuration (adjust URL as needed)
git clone /path/to/qry-nixos-config ~/nixos-config
# Or copy from USB if you have it there

# Move to system location
sudo mv ~/nixos-config /etc/nixos/
sudo chown -R root:root /etc/nixos/nixos-config
```

### Step 4: Copy Hardware Configuration

```bash
# Backup the generated hardware config
sudo cp /etc/nixos/hardware-configuration.nix /etc/nixos/nixos-config/hosts/framework12/hardware-configuration.nix

# Edit hostname in the hardware config if needed
sudo nano /etc/nixos/nixos-config/hosts/framework12/hardware-configuration.nix
```

### Step 5: Deploy QRY Configuration

```bash
# Navigate to configuration directory
cd /etc/nixos/nixos-config

# Build and switch to Framework 12 configuration
sudo nixos-rebuild switch --flake .#framework12

# This will take a while (downloading packages, building system)
# Go make coffee, this is your systematic installation moment!
```

### Step 6: Verify Installation

After the rebuild completes and you reboot:

```bash
# Test basic functionality
echo "=== QRY System Test ==="

# Test shell environment
zsh --version
starship --version

# Test development tools
go version
python3 --version
node --version
nvim --version

# Test creative applications
blender --version
godot4 --version
# reaper --version  # (will need GUI)

# Test AI tools
ollama --version
systemctl status ollama

# Test gaming
steam --version

# Test custom tools (once implemented)
# uroboro --version
# wherewasi --version
# doggowoof --version
```

### Step 7: Application Testing

**Desktop Environment**:
- [ ] GNOME loads correctly
- [ ] Display scaling appropriate
- [ ] Audio working (test with `speaker-test`)
- [ ] Network connectivity

**Creative Applications**:
- [ ] Blender launches and renders a cube
- [ ] Godot 4 opens and creates a new project
- [ ] Reaper opens and detects audio devices
- [ ] Can open and play games on Steam

**Development Environment**:
- [ ] Neovim with configuration works
- [ ] Zellij terminal multiplexer functions
- [ ] Git operations work
- [ ] Docker containers can run
- [ ] Go/Python/Node development works

**AI Tools**:
- [ ] Ollama service running
- [ ] Can pull and run a model: `ollama run llama3.2:latest`
- [ ] Aider can connect to local Ollama
- [ ] Jupyter Lab works for data science

**System Integration**:
- [ ] Automatic backups configured
- [ ] System monitoring active
- [ ] Firewall configured properly
- [ ] SSH access works

### Step 7: Framework 12 Specific Verification

**Hardware Verification**:
- [ ] All expansion cards detected
- [ ] WiFi 6E working
- [ ] Bluetooth connectivity
- [ ] Camera and microphone
- [ ] Battery management
- [ ] Power profiles switching
- [ ] Suspend/resume functionality
- [ ] HiDPI scaling correct

**Performance Tests**:
- [ ] CPU performance under load
- [ ] Memory usage with AI models
- [ ] Storage speed tests
- [ ] Graphics acceleration
- [ ] Thermal management

---

## Troubleshooting

### Common Issues and Solutions

**Boot Issues**:
```bash
# If system won't boot, use previous generation
# At GRUB menu, select previous configuration
# Then rollback: sudo nixos-rebuild switch --rollback
```

**Application Won't Start**:
```bash
# Check if package is installed
nix-shell -p <package-name>

# Check service status
systemctl status <service-name>

# Check logs
journalctl -u <service-name>
```

**Audio Issues**:
```bash
# Restart PipeWire
systemctl --user restart pipewire pipewire-pulse

# Check audio devices
pactl list short sinks
pactl list short sources
```

**Steam/Gaming Issues**:
```bash
# Enable Steam hardware support
# Add to configuration.nix:
# hardware.steam-hardware.enable = true;

# Check GameMode
gamemode --status
```

**Ollama/AI Issues**:
```bash
# Check service
systemctl status ollama

# Check logs
journalctl -u ollama -f

# Test connection
curl http://127.0.0.1:11434/api/version
```

### Performance Optimization

**If Debbie feels slow**:
```bash
# Check system resources
htop
iotop

# Clean up Nix store
sudo nix-collect-garbage -d

# Optimize Nix store
sudo nix-store --optimize
```

**If Framework 12 has battery issues**:
```bash
# Check power management
sudo tlp-stat
powertop

# Adjust power settings in configuration
```

---

## Testing Methodology

### Systematic Testing Approach

**Query Phase**:
- What specific functionality needs verification?
- What are the critical use cases for your workflow?
- What Framework 12 specific features need testing?

**Refine Phase**:
- Test each component systematically
- Document issues and solutions
- Optimize configurations for Framework 12

**Yield Phase**:
- Document working configurations
- Create troubleshooting guides
- Share successful Framework approaches

### Test Scripts

Create automated tests for critical functionality:

```bash
#!/bin/bash
# ~/test-qry-system.sh

echo "=== QRY System Integration Test ==="

# Test development environment
echo "Testing development tools..."
go version || echo "❌ Go not working"
python3 -c "import torch; print('✅ PyTorch available')" || echo "❌ PyTorch not working"

# Test creative applications
echo "Testing creative applications..."
timeout 10 blender --background --python-exit-code 1 -c "import bpy; bpy.ops.mesh.primitive_cube_add()" || echo "❌ Blender not working"

# Test AI stack
echo "Testing AI tools..."
curl -s http://127.0.0.1:11434/api/version >/dev/null && echo "✅ Ollama running" || echo "❌ Ollama not running"

# Test gaming
echo "Testing gaming..."
steam --version >/dev/null 2>&1 && echo "✅ Steam available" || echo "❌ Steam not working"

# Test Framework hardware
echo "Testing Framework 12 hardware..."
lsusb | grep -i framework && echo "✅ Framework hardware detected" || echo "❌ Framework hardware issues"

echo "=== Test Complete ==="
```

---

## Success Criteria

### Framework 12 Installation Success
- [ ] All applications launch successfully
- [ ] Development workflow functional
- [ ] Creative tools working
- [ ] AI stack operational
- [ ] Gaming platform ready
- [ ] Framework-specific hardware working
- [ ] Battery life acceptable (6+ hours normal use)
- [ ] Performance meets expectations
- [ ] System stable for 24+ hours
- [ ] No critical error messages in logs
- [ ] Can work on real projects immediately
- [ ] Backup and recovery tested

---

## Post-Installation

### Configuration Management

```bash
# Keep configuration in git
cd /etc/nixos/nixos-config
git add .
git commit -m "Working Framework 12 configuration"
git push

# Tag stable configuration
git tag framework12-stable-v1.0
```

### Ongoing Maintenance

```bash
# Weekly system updates
sudo nixos-rebuild switch --upgrade-all --flake .

# Monthly cleanup
sudo nix-collect-garbage -d
sudo nix-store --optimize

# Backup verification
borgmatic check --repository /home/qry/backups/framework12
```

### Documentation

Keep detailed notes of:
- Configuration changes and reasons
- Performance optimizations
- Application-specific tweaks
- Hardware-specific adjustments
- Useful aliases and functions

---

## Next Steps

Once the Framework 12 system is running smoothly:

1. **Install Custom Tools**: Add uroboro, wherewasi, doggowoof manually
2. **Optimize Workflows**: Create development environments for different projects
3. **Scale Configuration**: Adapt for additional machines
4. **Community Contribution**: Share successful Framework + NixOS patterns

**Remember**: This isn't just an OS installation—it's building the foundation for years of systematic, anti-fragile computing. Take time to understand each component and document your learnings.

**QRY Methodology in Action**: Query what you need, Refine through testing, Yield documented knowledge for future use.

---

*"The best time to test your backup strategy is before you need it. The second best time is right now."*

**Status**: Ready for systematic testing and deployment  
**Risk Level**: Low (multiple rollback options available)  
**Confidence**: High (systematic approach with proven components)