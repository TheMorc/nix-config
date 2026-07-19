{ config, modulesPath, pkgs, lib, ... }:
{
  imports = [ (modulesPath + "/virtualisation/proxmox-lxc.nix") ];

  nix.settings = { sandbox = false; };  

  proxmoxLXC = {
    manageNetwork = false;
    privileged = true;
  };

  services.fstrim.enable = false; # Let Proxmox host handle fstrim

  services.openssh = {
    openFirewall = true;
    settings = {
        PermitRootLogin = "yes";
        PasswordAuthentication = true;
        PermitEmptyPasswords = "yes";
    };
  };
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  boot.loader.systemd-boot.enable = false;
  
  system.stateVersion = "26.05";
}
