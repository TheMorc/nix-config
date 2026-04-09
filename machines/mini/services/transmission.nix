{
  config,
  lib,
  pkgs,
  ...
}:
{
  #transmission folder workaround (?)
  system.activationScripts.transmissionWorkaround = ''
    mkdir -p /mini_local/transmission/.config/transmission-daemon
    chown transmission:transmission -R /mini_local/transmission/.config/transmission-daemon
    chmod 770 -R /mini_local/transmission/.config/transmission-daemon
  '';

  services.transmission = {
    enable = true;
    package = pkgs.transmission_4;
    home = "/mini_local/transmission";
    settings.download-dir = "/mini_enterprise/av/transmission";
    settings.incomplete-dir-enabled = false;
  };
}
