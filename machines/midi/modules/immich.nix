{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  #immich folder workaround (?)
  system.activationScripts.immichWorkaround = ''
    mkdir -p /home/midi/immich
    chown immich:immich -R /home/midi/immich/
    chmod 770 -R /home/midi/immich/
  '';

  services.immich = {
    enable = true;
    port = 2283;
    mediaLocation = "/home/midi/immich/";
  };
}
