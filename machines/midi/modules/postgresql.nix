{ config, lib, ... }:
{

  #postgresql folder workaround (?)
  system.activationScripts.postgresWorkaround = ''
    mkdir -p /tank/services/postgresql/${config.services.postgresql.package.psqlSchema}
    chown postgres:postgres -R /tank/services/postgresql/${config.services.postgresql.package.psqlSchema}
    chmod 700 -R /tank/services/postgresql/${config.services.postgresql.package.psqlSchema}
  '';

  services.postgresql = {
    enable = true;
    dataDir = "/tank/services/postgresql/${config.services.postgresql.package.psqlSchema}";

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
