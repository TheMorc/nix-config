{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ../jukebox.nix
  ];

  networking.hostName = "jukebox";

  boot.kernelParams = [ "intel_idle.max_cstate=1" ];
  boot.loader.systemd-boot.consoleMode = "max";
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkDefault true;

  security.sudo.wheelNeedsPassword = false;
}
