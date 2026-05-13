{
  config,
  pkgs,
  inputs,
  ...
}:
{
  systemd.timers."magio-xmltv" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Sat *-*-* 3:00:00";
      Unit = "magio-xml.service";
    };
  };

  systemd.services."magio-xmltv" = {
    script = ''
      ${pkgs.bash}/bin/bash -c "cd /mini_local/magio-xmltv/server;source bin/activate; source credentials;flask run --host=0.0.0.0"
      ${pkgs.git}/bin/git -C /mini_local/magio-xmltv fetch
      ${pkgs.git}/bin/git -C /mini_local/magio-xmltv pull

      ${pkgs.coreutils}/bin/cp /mini_local/magio-xmltv/server/public/magioGuide.xmltv /mini_local/magio-xmltv/magio.xml
      ${pkgs.git}/bin/git -C /mini_local/magio-xmltv add --all
      ${pkgs.bash}/bin/bash -c "${pkgs.git}/bin/git -C /mini_local/magio-xmltv commit -m 'XMLTV Sync: $(${pkgs.coreutils}/bin/date)'"

      ${pkgs.git}/bin/git -C /mini_local/magio-xmltv push
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "mini";
    };

  };
}
