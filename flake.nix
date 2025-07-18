{
  description = "QRY Framework 12 + NixOS: Systematic Development Environment";

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

      # Common configuration for both hosts
      commonModules = [
        # Enable flakes system-wide
        ({ ... }: {
          nix.settings.experimental-features = [ "nix-command" "flakes" ];
          nixpkgs.config.allowUnfree = true;
        })

        # Import our custom modules
        ./modules/common.nix
        ./modules/development.nix
        ./modules/creative.nix
        ./modules/gaming.nix
        ./modules/ai-tools.nix

        # Home-manager integration
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.qry = import ./home.nix;
          home-manager.extraSpecialArgs = { inherit inputs; };
        }

        # Musnix for pro audio
        musnix.nixosModules.musnix
      ];
    in
    {
      # Test configuration for Debian desktop (Debbie)
      nixosConfigurations.debbie = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = commonModules ++ [
          ./hosts/debbie/configuration.nix
          ./hosts/debbie/hardware-configuration.nix
        ];
      };

      # Production configuration for Framework 12
      nixosConfigurations.framework12 = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs; };
        modules = commonModules ++ [
          # Framework 12 specific hardware support
          nixos-hardware.nixosModules.framework-13-7040-amd  # Adjust for your model
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
          echo "  - debbie (test configuration)"
          echo "  - framework12 (production configuration)"
          echo ""
          echo "To build and switch:"
          echo "  sudo nixos-rebuild switch --flake .#debbie"
          echo "  sudo nixos-rebuild switch --flake .#framework12"
        '';
      };
    };
}
