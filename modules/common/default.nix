{ ... }: {
  imports = [
    ./boot.nix
    ./locale.nix
    ./user.nix
    ./network.nix
    ./audio.nix
    ./impermanence.nix
    ./secrets.nix
    ./core.nix
  ];
}
