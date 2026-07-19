{
  lib,
  config,
  pkgs,
  inputs,
  stdenv,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  networking.hostName = "midi";

  boot.loader.efi.canTouchEfiVariables = false;

  environment = {
    systemPackages = with pkgs; [
      fastfetch
      gh
    ];
  };

  services = {
  };

  programs = {
  };

}
