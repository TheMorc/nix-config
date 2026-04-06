{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.samba = {
    enable = true;
    securityType = "user";
    openFirewall = true;
    settings = {
      global = {
        "workgroup" = "WORKGROUP";
        "server min protocol" = "NT1";
        "server signing" = "disabled";
        "smb encrypt" = "disabled";
        "client min protocol" = "NT1";
        "lanman auth" = "yes";
        "ntlm auth" = "yes";
        "security" = "user";
        "wins support" = "yes";
        "passdb backend" = "tdbsam";
        "domain master" = "yes";

        "include" = "registry";
        "guest account" = "nobody";
        "usershare allow guests" = "yes";

        "vfs objects" = "catia fruit streams_xattr";
        "fruit:aapl" = "yes";
        "fruit:nfs_aces" = "no";
        "fruit:zero_file_id" = "yes";
        "fruit:metadata" = "stream";
        "fruit:encoding" = "native";
        "spotlight backend" = "tracker";


        "readdir_attr:aapl_rsize" = "no";
        "readdir_attr:aapl_finder_info" = "no";
        "readdir_attr:aapl_max_access" = "no";

        "fruit:model" = "Macmini9,1";
        "fruit:posix_rename" = "yes";
        "fruit:veto_appledouble" = "no";
        "fruit:wipe_intentionally_left_blank_rfork" = "yes";
        "fruit:delete_empty_adfiles" = "yes";
      };
      "mini_enterprise" = {
        "path" = "/mini_enterprise";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "mini";
        "force group" = "users";
      };
    };
  };

  services.samba-wsdd = {
    enable = true;
  };

}
