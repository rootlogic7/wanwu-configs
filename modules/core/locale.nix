{ ... }: {
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  
  console.keyMap = "de-latin1-nodeadkeys";
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };
}
