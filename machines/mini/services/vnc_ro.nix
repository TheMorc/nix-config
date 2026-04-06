{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.x11vnc
  ];

  systemd.user.services.vnc_ro = {
    enable = true;
    wantedBy = ["default.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.x11vnc}/bin/x11vnc -display :0 -viewonly -forever -shared'';
      Restart = "always";
      RuntimeMaxSec = 60;
    };
  };
}
