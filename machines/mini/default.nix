# Mac mini

{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    inputs.apple-silicon-support.nixosModules.apple-silicon-support
    ../server.nix
    ./services
  ];

  networking.hostName = "mini";

  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.systemd-boot.enable = lib.mkDefault true;

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  security.sudo.wheelNeedsPassword = false;
}
