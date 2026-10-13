{ config, lib, ... }:
{

  #postgresql folder workaround (?)
  system.activationScripts.postgresWorkaround = ''
    mkdir -p /home/midi/postgresql/${config.services.postgresql.package.psqlSchema}
    chown postgres:postgres -R /home/midi/postgresql/${config.services.postgresql.package.psqlSchema}
    chmod 700 -R /home/midi/postgresql/${config.services.postgresql.package.psqlSchema}
  '';

  services.postgresql = {
    enable = true;
    dataDir = "/home/midi/postgresql/${config.services.postgresql.package.psqlSchema}";

  };
  services.postgresql.settings.listen_addresses = lib.mkForce "*";
  services.postgresql = {

    ensureDatabases = [
      "immich"
    ];

    ensureUsers = [
      {
        name = "immich";
        ensureDBOwnership = true;
      }
    ];
  };
}
