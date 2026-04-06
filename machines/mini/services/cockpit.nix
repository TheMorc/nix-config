{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.cockpit
  ];

  services.cockpit.enable = true;
}
