{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  #mcgalaxy group workaround
  system.activationScripts.mcgalaxyWorkaround = ''
    mkdir -p /mini_local/mcgalaxy/
    chown mcgalaxy:mcgalaxy -R /mini_local/mcgalaxy/
    chmod 770 -R /mini_local/mcgalaxy/
  '';

  environment.systemPackages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mcgalaxy
  ];

  users.groups.mcgalaxy = { };

  users.users.mcgalaxy = {
    isSystemUser = true;
    group = "mcgalaxy";
  };

  systemd.services.mcgalaxy = {
    enable = true;
    wantedBy = [ "default.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.mcgalaxy}/bin/MCGalaxyCLI";
      User = "mcgalaxy";
      Group = "mcgalaxy";
      Restart = "always";
      WorkingDirectory = "/mini_local/mcgalaxy";
    };
  };
}
