{ pkgs, ... }: {
  users.users.zhenren = {
    isNormalUser = true;
    description = "Zhenren";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    hashedPasswordFile = config.sops.secrets."users/zhenren/password".path;
  };
}
