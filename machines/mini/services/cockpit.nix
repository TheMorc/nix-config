{
  config,
  lib,
  pkgs,
  ...
}:
{
  environment.systemPackages = [
    pkgs.cockpit
  ];

  services.cockpit.enable = true;
  services.cockpit.allowed-origins = [ "https://*:9090" "https://*:373" ];
  services.cockpit.settings = {
    WebService = {
      AllowUnencrypted = true;
      ProtocolHeader = "X-Forwarded-Proto";
    };
  };
}
