{ pkgs, ... }: {
  # Rtkit wird von Pipewire für Echtzeit-Audio-Priorität empfohlen
  security.rtkit.enable = true;
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # Wichtig, falls du mal Wine oder alte Spiele nutzt
    pulse.enable = true;
    
    # Optional: Wireplumber ist der moderne Session-Manager für Pipewire
    wireplumber.enable = true; 
  };
}
