{ config, pkgs, ... }: 
let
  theme = import ./theme.nix;
in { 
  # Wichtig für Home Manager: Die State Version muss gesetzt sein
  home.stateVersion = "26.05";
}
