{
  description = "Wanwu Configs: The ten thousand manifestations of the Dao in NixOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, impermanence, sops-nix, home-manager, ... }@inputs: {
    
    nixosConfigurations = {
      # ---------------------------------------------------------
      # HOST 1: workstation
      # ---------------------------------------------------------
      workstation = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager

          ./hosts/workstation/disko.nix
          # ./hosts/workstation/hardware-configuration.nix
          ./hosts/workstation/default.nix
        ];
      };

      # ---------------------------------------------------------
      # HOST 2: thinkpad
      # ---------------------------------------------------------
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager

          ./hosts/thinkpad/disko.nix
          ./hosts/thinkpad/hardware-configuration.nix
          ./hosts/thinkpad/default.nix
        ];
      };
    };
  };
}
