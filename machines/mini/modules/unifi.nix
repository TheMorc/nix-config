{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.unifi.enable = true;
  services.unifi.mongodbPackage = pkgs.mongodb-ce;
}
