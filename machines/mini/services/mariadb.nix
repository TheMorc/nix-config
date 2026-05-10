{ config, lib, pkgs, ... }:
{

  system.activationScripts.mysqlWorkaround = ''
    mkdir -p /mini_local/mariadb/
    chown mysql:mysql -R /mini_local/mariadb/
    chmod 700 -R /mini_local/mariadb/
  '';

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    dataDir = "/mini_local/mariadb";
  };
}
