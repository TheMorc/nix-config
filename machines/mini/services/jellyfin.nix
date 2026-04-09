{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.jellyfin = {
    enable = true;
    dataDir = "/mini_local/jellyfin/";
    user = "mini";
    group = "users";
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
