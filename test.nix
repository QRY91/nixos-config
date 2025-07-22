# Minimal test configuration to isolate NixOS syntax issues
{ config, lib, pkgs, inputs, ... }:

{
  # Basic system configuration
  system.stateVersion = "24.05";

  # Essential boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Basic networking
  networking.hostName = "test";
  networking.networkmanager.enable = true;

  # Basic user
  users.users.qry = {
    isNormalUser = true;
    description = "QRY Test User";
    extraGroups = [ "wheel" "networkmanager" ];
    shell = pkgs.zsh;
  };

  # Enable flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Test individual modules one by one
  # Comment/uncomment these to isolate issues:

  # imports = [
  #   ./modules/common.nix
  # ];

  # imports = [
  #   ./modules/common.nix
  #   ./modules/development.nix
  # ];

  # imports = [
  #   ./modules/common.nix
  #   ./modules/development.nix
  #   ./modules/creative.nix
  # ];

  # imports = [
  #   ./modules/common.nix
  #   ./modules/development.nix
  #   ./modules/creative.nix
  #   ./modules/gaming.nix
  # ];

  # imports = [
  #   ./modules/common.nix
  #   ./modules/development.nix
  #   ./modules/creative.nix
  #   ./modules/gaming.nix
  #   ./modules/ai-tools.nix
  # ];

  # Test basic packages
  environment.systemPackages = with pkgs; [
    git
    vim
    curl
    wget
  ];

  # Test services
  services.openssh.enable = true;

  # Test shell configuration
  programs.zsh.enable = true;
}
