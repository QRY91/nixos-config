{
  description = "QRY Framework 12 - Minimal Working Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.framework12 = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ({ config, pkgs, ... }: {
            # Import hardware configuration
            imports = [
              ./hosts/framework12/hardware-configuration.nix
            ];

            # Boot loader
            boot.loader.systemd-boot.enable = true;
            boot.loader.efi.canTouchEfiVariables = true;

            # Networking
            networking.hostName = "framework12";
            networking.networkmanager.enable = true;

            # Enable flakes
            nix.settings.experimental-features = [ "nix-command" "flakes" ];
            nixpkgs.config.allowUnfree = true;

            # Desktop environment
            services.xserver.enable = true;
            services.xserver.displayManager.gdm.enable = true;
            services.xserver.desktopManager.gnome.enable = true;

            # User account
            users.users.qry = {
              isNormalUser = true;
              description = "QRY";
              extraGroups = [ "wheel" "networkmanager" ];
              shell = pkgs.zsh;
            };

            # Enable zsh
            programs.zsh.enable = true;

            # Basic packages
            environment.systemPackages = with pkgs; [
              firefox
              git
              vim
              curl
              wget
              htop
            ];

            # SSH
            services.openssh.enable = true;

            # Audio
            sound.enable = true;
            hardware.pulseaudio.enable = true;

            # This is required
            system.stateVersion = "24.05";
          })
        ];
      };
    };
}
