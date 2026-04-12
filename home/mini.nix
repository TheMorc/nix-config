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
    username = "mini";
    homeDirectory = "/home/mini";
    stateVersion = "26.05";
    file = {
      ".ssh/id_ed25519.pub".source = ../dot/id_ed25519.pub;
      ".config/autostart/conky.desktop".source = ../dot/conky.desktop;
      ".config/autostart/netsurf.desktop".source = ../dot/netsurf.desktop;
      ".config/gtk-3.0/settings.ini".source = ../dot/gtk_settings.ini;
      ".config/gtk-3.0/settings.ini".force = true;
      ".config/netsurf/Choices".source = ../dot/netsurf_Choices;
      ".config/netsurf/Choices".force = true;
      ".config/openbox/rc.xml".source = ../dot/openbox_rc.xml;
      ".config/openbox/rc.xml".force = true;
      ".config/lxqt/lxqt.conf".source = ../dot/lxqt.conf;
      ".config/lxqt/lxqt.conf".force = true;
      ".config/lxqt/panel.conf".source = ../dot/lxqt_panel.conf;
      ".config/lxqt/panel.conf".force = true;
      ".config/conky/conky.conf".source = ../dot/conky.conf;
      ".config/chromium/Default/Preferences".source = ../dot/chromium_Preferences;
      ".config/chromium/Default/Preferences".force = true;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/html" = "firefox.desktop";
      "x-scheme-handler/http" = "firefox.desktop";
      "x-scheme-handler/https" = "firefox.desktop";
      "x-scheme-handler/about" = "firefox.desktop";
      "x-scheme-handler/unknown" = "firefox.desktop";
    };
  };
}
