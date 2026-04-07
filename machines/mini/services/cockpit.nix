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

  services.cockpit = {
    enable = true;
    allowed-origins = [
      "http://*:9090"
      "https://*:373"
    ];
    settings = {
      WebService = {
        AllowUnencrypted = true;
        ProtocolHeader = "X-Forwarded-Proto";
      };
    };
  };

}
