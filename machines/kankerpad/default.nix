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

  networking.hostName = "KankerPad";

  services = {
    desktopManager.plasma6.enable = true;
    displayManager.sddm.enable = true;
    printing.enable = true;
  };

  
  console.keyMap = "de";
  services.xserver.xkb.layout = "de";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = lib.genAttrs [
      "LC_ADDRESS"
      "LC_IDENTIFICATION"
      "LC_NAME"
      "LC_MEASUREMENT"
      "LC_NUMERIC"
      "LC_MONETARY"
      "LC_PAPER"
      "LC_TELEPHONE"
      "LC_TIME"
    ] (var: "de_DE.UTF-8");
  };
}
