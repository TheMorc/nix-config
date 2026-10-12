{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.xrdp = {
    enable = true;
    defaultWindowManager = "chromium-browser --start-fullscreen --kiosk --noerrdialogs --disable-infobars 'http://localhost:8123/lovelace/default_view'";
  };

  systemd.user.timers."kiosk_clr_rdp_cache" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sun *-*-* 5:00:00";
      Unit = "kiosk_clr_rdp_cache.service";
    };
  };

  systemd.user.services."kiosk_clr_rdp_cache" = {
    script = ''
            	${pkgs.sshpass}/bin/sshpass -p alpine \
      	${pkgs.openssh}/bin/ssh -oHostKeyAlgorithms=+ssh-rsa \
      	root@Richards-iPad -tt "rm -rf /var/mobile/Containers/Data/Application/9D22038F-392D-4227-A511-225A637C1978/Library/Caches/"
    '';
    serviceConfig = {
      Type = "oneshot";
      Environment = [
        "SSH_ASKPASS="
        "SSH_ASKPASS_REQUIRE=never"
      ];
    };
  };
}
