{
  config,
  pkgs,
  inputs,
  ...
}:
{

  virtualisation.waydroid.enable = true;

  systemd.user.services.waydroid = {
    enable = true;
    partOf = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.waydroid}/bin/waydroid session start";
      User = "htpc";
      Group = "users";
    };
  };
}
