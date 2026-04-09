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

  systemd.user.services.vnc = {
    enable = true;
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.x11vnc}/bin/x11vnc -display :0 -rfbport 5901 -forever -shared";
      Restart = "always";
    };
  };
}
