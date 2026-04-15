{ config, pkgs, lib, inputs, ... }: {
  
  imports = [
    ./boot.nix
    ./locale.nix
    ./network.nix
    ./audio.nix
    ./impermanence.nix
    ./secrets.nix
  ];

  # ===========================================================================
  # OPTIONEN (Hier definieren wir die Schalter)
  # ===========================================================================
  options.mainUser = lib.mkOption {
    type = lib.types.str;
    default = "haku";
    description = "Primary System User";
  };

  # ===========================================================================
  # CONFIG (Hier setzen wir die tatsächlichen System-Werte)
  # ===========================================================================
  config = {
    # 1. GLOBALE NIX-SETTINGS
    nix.settings.experimental-features = [ "nix-command" "flakes" ];
    nix.settings.auto-optimise-store = true;
    nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    environment.systemPackages = with pkgs; [
      git
      nano
      htop
      wget
    ];

    # 2. SYSTEM-USER & RECHTE
    users.users.${config.mainUser} = {
      isNormalUser = true;
      description = "Primary System User";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
      hashedPasswordFile = config.sops.secrets."users/${config.mainUser}/password".path;
    };

    # 3. HOME MANAGER GRUNDGERÜST
    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs; };
      
      users.${config.mainUser} = {
        home.stateVersion = "26.05";
      };
    };
  };
}
