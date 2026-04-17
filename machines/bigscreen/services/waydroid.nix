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
      ExecStart = "${pkgs.waydroid}/bin/waydroid session start";
      ExecStop = "${pkgs.waydroid}/bin/waydroid session stop";
      
      KillMode = "mixed";
      
      MemoryMax = "4G";
      MemoryHigh = "3G";
      
      TimeoutStopSec = "15s";
      Restart = "on-failure";
    };
  };
}
