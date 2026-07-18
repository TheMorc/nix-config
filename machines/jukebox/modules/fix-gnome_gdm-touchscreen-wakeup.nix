{ config, pkgs, ... }:
{

  environment.systemPackages = with pkgs; [
    evsieve
  ];

  systemd.services.fix-gnome_gdm-touchscreen-wakeup = {
    enable = true;
    description = "Wake up workaround fix for GNOME/GDM not being able to wake up from lockscreen via touchscreen";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-udevd.service" ];

    serviceConfig = {
      ExecStart = ''
        ${pkgs.evsieve}/bin/evsieve \
          --input /dev/input/by-id/usb-USBest_Technology_SiS_HID_Touch_Controller-event-if00 \
          --copy btn:touch \
          --map btn:touch key:wakeup \
          --output
      '';

      Restart = "always";
      RestartSec = 1;
    };
  };
}
