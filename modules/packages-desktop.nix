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
    thunderbird.enable = true;
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
    wireshark = {
      enable = true;
      usbmon.enable = true;
    };
  };

  environment.systemPackages = with pkgs; [
    alvr
    bitwarden-desktop
    edl
    gimp3-with-plugins
    ifuse
    kdePackages.sddm-kcm
    libreoffice-qt6-fresh
    milkytracker
    obs-studio
    pmbootstrap
    prismlauncher
    remmina
    transmission_4-qt
    tree
    mpv
    vlc
    yt-dlp

  ];
}
