{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    ports = [
      22
      24
    ];
  };

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = lib.getExe pkgs.kdePackages.ksshaskpass;
  };
}
