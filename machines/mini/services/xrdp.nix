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
}
