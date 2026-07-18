{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  networking.hostName = "LatitudeE7270";

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    printing.enable = true;
  };
}
