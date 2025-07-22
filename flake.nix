{
  description = "QRY Framework 12 NixOS: Systematic Development Environment";

  inputs = {
    # Main nixpkgs - unstable for latest packages and Framework 12 support
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home-manager for user-specific configuration
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Musnix for pro audio (Reaper, low-latency audio)
    musnix = {
      url = "github:musnix/musnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hardware-specific configurations
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, musnix, nixos-hardware, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      # Common configuration for Framework 12
      # Enable modules gradually in this order:
      commonModules = [
        # Enable flakes system-wide
        ({ ... }: {
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
          nixpkgs.config.allowUnfree = true;
        })

        # STEP 1: Start with common module (always enabled)
        ./modules/common.nix

        # STEP 2: Add development tools (uncomment when ready)
        # ./modules/development.nix

        # STEP 3: Add creative applications (uncomment when ready)
        # ./modules/creative.nix

        # STEP 4: Add gaming support (uncomment when ready)
        # ./modules/gaming.nix

        # STEP 5: Add AI tools (uncomment when ready)
        # ./modules/ai-tools.nix

        # STEP 6: Add home-manager (uncomment when ready)
        # home-manager.nixosModules.home-manager
        # {
        #   home-manager.useGlobalPkgs = true;
        #   home-manager.useUserPackages = true;
        #   home-manager.users.qry = import ./home.nix;
        #   home-manager.extraSpecialArgs = { inherit inputs; };
        # }

        # STEP 7: Add pro audio support (uncomment when ready)
        # musnix.nixosModules.musnix
      ];
    in
    {


      # Production configuration for Framework 12
      nixosConfigurations.framework12 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = commonModules ++ [
          # Framework 12 specific hardware support
          # Note: Framework 12 may not have specific nixos-hardware module yet
          # nixos-hardware.nixosModules.framework-13-7040-amd  # Uncomment and adjust if available
          ./hosts/framework12/configuration.nix
          ./hosts/framework12/hardware-configuration.nix
          ./modules/framework.nix
        ];
      };

      # Development shell for testing configurations
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          nixos-rebuild
          home-manager
          git
          vim
        ];

        shellHook = ''
          echo "QRY NixOS Development Environment"
          echo "Available configurations:"
          echo "  - test (minimal test configuration)"
          echo "  - framework12 (production configuration)"
          echo ""
          echo "To build and switch:"
          echo "  sudo nixos-rebuild switch --flake .#test"
          echo "  sudo nixos-rebuild switch --flake .#framework12"
        '';
      };
    };
}
