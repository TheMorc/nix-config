{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.tftpd = {
    enable = true;
    path = "/mini_local/tftp";
  };
}
