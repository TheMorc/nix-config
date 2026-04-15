# Dell Latitude E7270

{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../bigscreen.nix
    ./services
  ];

  networking.hostName = "bigscreen";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkDefault true;

  security.sudo.wheelNeedsPassword = false;
}
