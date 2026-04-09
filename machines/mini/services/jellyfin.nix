{
  config,
  lib,
  pkgs,
  ...
}:
{
  #jellyfin group workaround
  system.activationScripts.jellyfinWorkaround = ''
    mkdir -p /mini_local/jellyfin/
    chown transmission:transmission -R /mini_local/jellyfin/.
    chmod 770 -R /mini_local/jellyfin/
  '';

  services.jellyfin = {
    enable = true;
    dataDir = "/mini_local/jellyfin/";
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];
}
