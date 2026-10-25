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
    mkdir -p /tank/services/immich
    chown immich:immich -R /tank/services/immich/
    chmod 770 -R /tank/services/immich/
  '';

  services.immich = {
    enable = true;
    port = 2283;
    mediaLocation = "/tank/services/immich/";
  };
}
