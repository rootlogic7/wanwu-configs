{ config, pkgs, lib, ... }: {
  # 1. Option definieren
  options.mainUser = lib.mkOption {
    type = lib.types.str;
    default = "haku";
    description = "Primary System User";
  };
  config = {
    users.users.${config.mainUser} = {
      isNormalUser = true;
      description = "Primary System User";
      extraGroups = [ "networkmanager" "wheel" "video" "audio" ];
      hashedPasswordFile = config.sops.secrets."users/${config.mainUser}/password".path;
    };
  };
}
