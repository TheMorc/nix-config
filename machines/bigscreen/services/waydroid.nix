{
  config,
  pkgs,
  inputs,
  ...
}:
{

  virtualisation.waydroid.enable = true;

  systemd.user.services.waydroid-session = {
    enable = true;
    description = "Waydroid User Session";
    after = [ "waydroid-container.service" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.waydroid}/bin/waydroid";
      ExecStop = "${pkgs.waydroid}/bin/waydroid container stop";

      KillMode = "mixed";

      MemoryMax = "4G";
      MemoryHigh = "3G";

      TimeoutStopSec = "15s";
      Restart = "on-failure";
    };
  };

  systemd.user.services.waydroid-boothide = {
    enable = true;
    description = "Hide Waydroid Session during boot";

    after = [ "waydroid-session.service" ];
    requires = [ "waydroid-session.service" ];

    script = ''
      ${pkgs.coreutils}/bin/sleep 30
      ${pkgs.qt6.qttools}/bin/qdbus org.kde.KWin /Scripting loadScript ~/.local/share/waydroid_minimize.js
      ${pkgs.qt6.qttools}/bin/qdbus org.kde.KWin /Scripting start
    '';

    serviceConfig = {
      Type = "oneshot";
    };

    wantedBy = [ "default.target" ];
  };
}
