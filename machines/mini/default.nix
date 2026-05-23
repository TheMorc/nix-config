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

  nix.settings = {
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
    ];
  };

  boot.loader.efi.canTouchEfiVariables = false;
  boot.loader.systemd-boot.enable = lib.mkDefault true;

  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  security.sudo.wheelNeedsPassword = false;
}
