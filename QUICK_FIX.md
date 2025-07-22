# Quick Fix for Framework 12 NixOS Configuration

## The Problem
You're getting errors because the `hardware-configuration.nix` file is a placeholder. NixOS needs the actual hardware configuration generated during installation.

## The Solution

### Step 1: Replace Hardware Configuration
On your Framework 12, after the base NixOS installation:

```bash
# Navigate to your cloned configuration
cd /etc/nixos/nixos-config

# Replace the placeholder with your actual hardware config
sudo cp /etc/nixos/hardware-configuration.nix ./hosts/framework12/hardware-configuration.nix

# Verify it looks right (should have your actual disk UUIDs and hardware)
cat ./hosts/framework12/hardware-configuration.nix
```

### Step 1.5: Check and Set Hostname
Check what your current hostname is and update if needed:

```bash
# Check current hostname
hostname

# Check what's in the configuration
grep "hostName" ./hosts/framework12/configuration.nix

# If you want to change it, edit the configuration:
sudo nano ./hosts/framework12/configuration.nix
# Look for: networking.hostName = "framework12";
# Change "framework12" to whatever you prefer (e.g., "qry-framework", "qry-laptop", etc.)

# Generate a unique hostId (required for some NixOS features)
head -c 8 /etc/machine-id
# Copy this value and update the hostId line in configuration.nix:
# networking.hostId = "your-8-char-id-here";
```

### Step 2: Gradual Module Enablement
The flake is currently configured with most modules disabled to avoid conflicts. Enable them one by one:

```bash
# Edit the flake.nix file
sudo nano flake.nix
```

Uncomment the modules in this order, testing after each one:

1. **First test** - Just common module (already enabled):
```bash
sudo nixos-rebuild switch --flake .#framework12
```

2. **Add development module** - Uncomment this line in flake.nix:
```nix
./modules/development.nix
```
Then test:
```bash
sudo nixos-rebuild switch --flake .#framework12
```

3. **Add remaining modules** one by one:
```nix
./modules/creative.nix
./modules/gaming.nix  
./modules/ai-tools.nix
```

4. **Finally, add home-manager**:
```nix
# Home-manager integration
home-manager.nixosModules.home-manager
{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.qry = import ./home.nix;
  home-manager.extraSpecialArgs = { inherit inputs; };
}
```

5. **Add musnix for audio**:
```nix
# Musnix for pro audio
musnix.nixosModules.musnix
```

### Step 3: If You Get Errors

**For "attribute already defined" errors:**
- Look at the error message to see which file and line
- Usually means there's a duplicate configuration
- Comment out one of the duplicate lines

**For "path does not exist" errors:**
- Make sure all files referenced in the flake actually exist
- Check file paths are correct

### Step 4: Quick Test Commands

```bash
# Test flake syntax without building
nix --extra-experimental-features nix-command --extra-experimental-features flakes flake check

# Build without switching (safer)
sudo nixos-rebuild build --flake .#framework12

# Build and test (temporary, reverts on reboot)
sudo nixos-rebuild test --flake .#framework12

# Build and switch (permanent)
sudo nixos-rebuild switch --flake .#framework12
```

### Step 5: Emergency Rollback

If something breaks:
```bash
# Boot into previous generation from GRUB menu
# OR
sudo nixos-rebuild switch --rollback
```

## Expected Timeline
- Step 1: 2 minutes
- Step 2: 15-30 minutes (testing each module)
- Total: ~30 minutes to working system

## What Should Work After Each Step

**After Step 1 (common only):**
- Basic NixOS boots
- Network works
- User account exists

**After Step 2.2 (+ development):**
- Git, editors, programming languages
- Terminal multiplexer (zellij)
- Modern CLI tools

**After Step 2.3 (+ creative):**
- Blender, Godot, creative apps

**After Step 2.4 (+ gaming):**
- Steam, gaming tools

**After Step 2.5 (+ ai-tools):**
- Ollama, AI development stack

**After Step 2.6 (+ home-manager):**
- User-specific configurations
- Shell aliases and prompt

**After Step 2.7 (+ musnix):**
- Professional audio support

## Troubleshooting Tips

1. **Build fails on first module?** 
   - Check `/etc/nixos/nixos-config/hosts/framework12/hardware-configuration.nix` exists
   - Verify it has your actual hardware (not placeholder text)

2. **Specific package not found?**
   - Check if package name is correct for nixpkgs unstable
   - Comment out problematic packages temporarily

3. **Services fail to start?**
   - Some services need hardware that might not be available
   - Comment out problematic services temporarily

4. **Home-manager errors?**
   - Check `./home.nix` exists and has valid syntax
   - Temporarily disable home-manager section if needed

## Success Criteria
- `sudo nixos-rebuild switch --flake .#framework12` completes without errors
- System boots successfully
- Basic applications work (terminal, browser, etc.)
- Framework 12 hardware is detected properly

---

**Remember:** This is systematic engineering - test each component individually, document what works, build incrementally. You can always rollback to previous working states.