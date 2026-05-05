{ config, lib, ... }:
{

  #postgresql folder workaround (?)
  system.activationScripts.postgresWorkaround = ''
    mkdir -p /mini_local/postgresql/${config.services.postgresql.package.psqlSchema}
    chown postgres:postgres -R /mini_local/postgresql/${config.services.postgresql.package.psqlSchema}
    chmod 700 -R /mini_local/postgresql/${config.services.postgresql.package.psqlSchema}
  '';

  services.postgresql = {
    enable = true;
    dataDir = "/mini_local/postgresql/${config.services.postgresql.package.psqlSchema}";

  };
  services.postgresql.settings.listen_addresses = lib.mkForce "*";
  services.postgresql = {

    ensureDatabases = [
      "hass"
      "immich"
    ];

    ensureUsers = [
      {
        name = "hass";
        ensureDBOwnership = true;
      }

      {
        name = "immich";
        ensureDBOwnership = true;
      }
    ];
  };
}
