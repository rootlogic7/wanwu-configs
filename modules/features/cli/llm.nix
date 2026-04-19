{ pkgs, lib, config, ... }:

{
  options.features.cli.llm = {
    enable = lib.mkEnableOption "Lokales LLM Setup mit Ollama und Aider";
  };

  config = lib.mkIf config.features.cli.llm.enable {
    # Ollama Daemon aktivieren
    services.ollama = {
      enable = true;
      package = pkgs.ollama; # Standard-Paket für CPUs (Intel/AMD)
    };

    # Tools für den User installieren
    environment.systemPackages = with pkgs; [
      aider-chat # Das KI-Pair-Programming Tool für das Terminal
    ];
  };
}
