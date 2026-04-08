{ config, pkgs, inputs, ... }:
{
  systemd.timers."skylink-xmltv" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      OnCalendar = "Sun *-*-* 3:00:00";
      Unit = "skylink-xml.service";
    };
  };

  systemd.services."skylink-xmltv" = {
  script = ''
    ${pkgs.git}/bin/git -C /home/mini/skylink-xmltv fetch
    ${pkgs.git}/bin/git -C /home/mini/skylink-xmltv pull

    ${pkgs.wget}/bin/wget http://localhost:9981/xmltv/channels -O /home/mini/skylink-xmltv/a3b_a1.xml
    ${pkgs.git}/bin/git -C /home/mini/skylink-xmltv add --all
    ${pkgs.bash}/bin/bash -c "${pkgs.git}/bin/git -C /home/mini/skylink-xmltv commit -m 'XMLTV Sync: $(${pkgs.coreutils}/bin/date)'"

    ${pkgs.git}/bin/git -C /home/mini/skylink-xmltv push
  '';
  serviceConfig = {
    Type = "oneshot";
    RemainAfterExit = true;
    User = "mini";
  };

  };
}
