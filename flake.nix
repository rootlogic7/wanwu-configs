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
      # HOST 1: WORKSTATION
      # ---------------------------------------------------------
      qian = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager

          ./hosts/qian/disko.nix
          # ./hosts/qian/hardware-configuration.nix
          ./hosts/qian/default.nix
        ];
      };

      # ---------------------------------------------------------
      # HOST 2: LAPTOP (ehemals nova nun xun)
      # ---------------------------------------------------------
      xun = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          inputs.sops-nix.nixosModules.sops
          home-manager.nixosModules.home-manager

          ./hosts/xun/disko.nix
          ./hosts/xun/hardware-configuration.nix
          ./hosts/xun/default.nix
        ];
      };
    };
  };
}
