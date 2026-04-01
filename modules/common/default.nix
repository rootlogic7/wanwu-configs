{ ... }: {
  imports = [
    ./boot.nix
    ./locale.nix
    ./user.nix
    ./network.nix
    ./impermanence.nix
    ./secrets.nix
    ./core.nix
  ];
}
