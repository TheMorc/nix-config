{
  config,
  lib,
  pkgs,
  ...
}:
{
  #immich folder workaround (?)
  system.activationScripts.immichWorkaround = ''
    mkdir -p /mini_enterprise/immich_library/
    chown immich:immich -R /mini_enterprise/immich_library/
    chmod 770 -R /mini_enterprise/immich_library/
  '';

  services.immich = {
    enable = true;
    port = 2283;
    mediaLocation = "/mini_enterprise/immich_library/";
  };
}
