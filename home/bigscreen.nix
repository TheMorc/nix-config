{ config, inputs, ... }:
{

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
      settings.user.name = "Richard Gráčik";
      settings.user.email = "r.gracik@370.network";
    };
    home-manager.enable = true;
  };

  home = {
    username = "htpc";
    homeDirectory = "/home/htpc";
    stateVersion = "26.05";
    file = {
      ".ssh/id_ed25519.pub".source = ../dot/id_ed25519.pub;
      ".local/share/applications/youtube.desktop".source = ../dot/youtube.desktop;
      ".local/share/youtube.png".source = ../dot/youtube.png;
      ".local/share/waydroid_maximize.js".source = ../dot/waydroid_maximize.js;
      ".local/share/waydroid_minimize.js".source = ../dot/waydroid_minimize.js;
      ".local/share/applications/SmartTube.desktop".source = ../dot/SmartTube.desktop;
      ".local/share/applications/VUPlayerPro.desktop".source = ../dot/VUPlayerPro.desktop;
      ".local/share/applications/Jellyfin.desktop".source = ../dot/Jellyfin.desktop;
    };
  };
}
