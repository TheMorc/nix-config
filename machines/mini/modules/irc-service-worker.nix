{ config, pkgs, ... }:
{

  users.users.ircServiceWorker = {
    isSystemUser = true;
    group = "ircServiceWorker";
    home = "/mini_local/ircServiceWorker";
  };

  users.groups.ircServiceWorker = { };

  systemd.services.ircServiceWorker = {
    description = "IRC Service Worker Python Project";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";

      User = "ircServiceWorker";
      Group = "ircServiceWorker";

      WorkingDirectory = "/mini_local/ircServiceWorker";

      ExecStart = "/mini_local/ircServiceWorker/bin/python main.py";

      Restart = "always";
      RestartSec = 5;
    };
  };
}
