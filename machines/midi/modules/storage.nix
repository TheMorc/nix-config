{ pkgs, ... }:

{
  boot.supportedFilesystems = [ "zfs" ];

  boot.zfs.extraPools = [ "tank" ];

  networking.hostId = "310c5092";

  environment.systemPackages = with pkgs; [
    zfs
  ];

  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "monthly";
    };

    trim = {
      enable = true;
      interval = "weekly";
    };
  };
}
