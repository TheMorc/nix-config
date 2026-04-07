{
  config,
  lib,
  pkgs,
  ...
}:
{

systemd.services.vaultwarden = {
    requires = [ "postgresql.target" ];
    after = [ "postgresql.target" ];
  };

services.postgresql = {
      ensureDatabases = [ "vaultwarden" ];
      ensureUsers = [
        {
          name = "vaultwarden";
          ensureDBOwnership = true;
        }
      ];
    };

    environment.systemPackages = [
      pkgs.vaultwarden-postgresql

    ];

  services.vaultwarden = {
    enable = true;
    dbBackend = "postgresql";
    # in order to avoid having  ADMIN_TOKEN in the nix store it can be also set with the help of an environment file
    # be aware that this file must be created by hand (or via secrets management like sops)
    environmentFile = "/var/lib/vaultwarden/vaultwarden.env";
    config = {
        # Refer to https://github.com/dani-garcia/vaultwarden/blob/main/.env.template
        DOMAIN = "https://biskupova.televiziastb.sk";
        DATABASE_URL = "postgresql:///vaultwarden?host=/run/postgresql";
        SIGNUPS_ALLOWED = true;
        ENABLE_WEBSOCKET = true;
        HTTP_REQUEST_BLOCK_NON_GLOBAL_IPS = false;
        IP_HEADER = "X-Forwarded-For";

        ROCKET_ADDRESS = "127.0.0.1";
        ROCKET_PORT = 8222;
        ROCKET_LOG = "critical";

        SMTP_HOST = "127.0.0.1";
        SMTP_PORT = 25;
        SMTP_SSL = false;

        SMTP_FROM = "admin@bitwarden.example.com";
        SMTP_FROM_NAME = "example.com Bitwarden server";
    };
};
}
