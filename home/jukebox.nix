{ config, inputs, ... }:
{

  programs = {
    home-manager.enable = true;
  };

  home = {
    username = "jukebox";
    homeDirectory = "/home/jukebox";
    stateVersion = "26.05";
    file = {
      ".ssh/id_ed25519.pub".source = ../dot/id_ed25519.pub;
      ".config/autostart/cider.desktop" = {
        enable = true;
        text = ''
          [Desktop Entry]
          Type=Application
          Name=Cider
          Exec=cider-2
          Terminal=false
          X-GNOME-Autostart-enabled=true
        '';
      };
    };
  };
}
