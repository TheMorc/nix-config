{ config, pkgs, ... }:
{

  users.users.threeseventyServiceWorker = {
    isSystemUser = true;
    group = "threeseventyServiceWorker";
    home = "/mini_local/threeseventyServiceWorker";
  };

  users.groups.threeseventyServiceWorker = { };

  systemd.services.threeseventyServiceWorker = {
    description = "370network Service Worker Python Project";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";

      User = "threeseventyServiceWorker";
      Group = "threeseventyServiceWorker";

      WorkingDirectory = "/mini_local/threeseventyServiceWorker";

      ExecStart = "/mini_local/threeseventyServiceWorker/bin/python worker-new-messages-and-ia.py";

      Restart = "always";
      RestartSec = 5;
    };
  };
}
