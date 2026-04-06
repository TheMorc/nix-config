{
  inputs,
  lib,
  pkgs,
  frostix,
  ...
}:

let
  selfPkgs = inputs.self.packages.${pkgs.system};
in
{

  services.usbmuxd.enable = true;
  services.flatpak.enable = true;
  networking.firewall.enable = false;

  programs = {
    firefox = {
      enable = true;
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
    ssh = {
      enableAskPassword = true;
      askPassword = lib.getExe pkgs.kdePackages.ksshaskpass;
    };
  };

  environment.systemPackages = with pkgs; [
    milkytracker
    obs-studio
    tree
    mpv
    yt-dlp

  ];
}
