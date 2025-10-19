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
  services.udev.packages = with pkgs; [
    android-udev-rules
    edl
    heimdall.udev
  ];

  services.usbmuxd.enable = true;
  services.tftpd.enable = true;
  services.tftpd.path = "/tftproot";
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
    bambu-studio
    bitwarden-desktop
    davinci-resolve
    discord-ptb
    edl
    gimp3-with-plugins
    heimdall
    hunspellDicts.de_DE
    hunspellDicts.en_US
    hunspellDicts.pl_PL
    hyphenDicts.de_DE
    hyphenDicts.en_US
    ifuse
    itgmania
    kdePackages.sddm-kcm
    libimobiledevice
    libmikmod
    libreoffice-qt6-fresh
    lutris
    mikmod
    milkytracker
    frostix.mtkclient-git
    obs-studio
    pmbootstrap
    prismlauncher
    remmina
    signal-desktop
    transmission-qt
    tree
    vlc
    vscode
    yt-dlp

    #selfPkgs.ida-pro
    selfPkgs.odin4
    selfPkgs.outfox-alpha5
    #selfPkgs.ttf-ms-win11
  ];
}
