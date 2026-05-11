{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        acl = [ "pattern readwrite #" ];
        omitPasswordAuth = true;
        settings.allow_anonymous = true;
      }
    ];

    bridges = {
      cheerlightsRGB = {
        addresses = [ { address = "mqtt.cheerlights.com"; port = 1883; } ];

        topics = [
          "cheerlightsRGB in"
        ];
      };
    };
  };
}
