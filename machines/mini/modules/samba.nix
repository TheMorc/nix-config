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
        workgroup = "WORKGROUP";
        "server min protocol" = "NT1";
        "server signing" = "disabled";
        "smb encrypt" = "disabled";
        "client min protocol" = "NT1";
        "lanman auth" = true;
        "ntlm auth" = true;
        "security" = "user";
        "wins support" = true;
        "passdb backend" = "tdbsam";
        "domain master" = true;

        "include" = "registry";
        "guest account" = "nobody";
        "usershare allow guests" = true;

        "vfs objects" = "catia fruit streams_xattr";
        "fruit:aapl" = true;
        "fruit:nfs_aces" = false;
        "fruit:zero_file_id" = true;
        "fruit:metadata" = "stream";
        "fruit:encoding" = "native";
        "spotlight backend" = "tracker";

        "readdir_attr:aapl_rsize" = false;
        "readdir_attr:aapl_finder_info" = false;
        "readdir_attr:aapl_max_access" = false;

        "fruit:model" = "Macmini9,1";
        "fruit:posix_rename" = true;
        "fruit:veto_appledouble" = false;
        "fruit:wipe_intentionally_left_blank_rfork" = true;
        "fruit:delete_empty_adfiles" = true;
      };
      "mini" = {
        "path" = "/home/mini";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "mini";
        "force group" = "users";
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
      "mini_local" = {
        "path" = "/mini_local";
        "browseable" = "yes";
        "read only" = "no";
        "guest ok" = "yes";
        "create mask" = "0644";
        "directory mask" = "0755";
        "force user" = "mini";
        "force group" = "users";
      };
      "webserver" = {
        "path" = "/mini_local/www";
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
    discovery = true;
  };

services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
    extraServiceFiles = {
      smb = ''
        <?xml version="1.0" standalone='no'?>
        <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
        <service-group>
          <name replace-wildcards="yes">%h</name>
          <service>
            <type>_smb._tcp</type>
            <port>445</port>
          </service>
          <service>
            <type>_device-info._tcp</type>
            <port>0</port>
            <txt-record>model=Macmini9,1</txt-record>
          </service>
        </service-group>
      '';
    };
  };

}
