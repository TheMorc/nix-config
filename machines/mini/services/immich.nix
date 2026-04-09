{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.immich = {
    enable = true;
    port = 2283;
    mediaLocation = "/mini_enterprise/immich_library/";
  };
}
