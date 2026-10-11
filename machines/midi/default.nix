{
  lib,
  config,
  pkgs,
  inputs,
  stdenv,
  vars,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  networking.hostName = "midi";

  boot.loader.efi.canTouchEfiVariables = false;

  environment = {
    systemPackages = with pkgs; [
      fastfetch
      gh
    ];
  };

  users = {
    mutableUsers = false;
    users.midi = {
      isNormalUser = true;
      description = "Server User account";
      extraGroups = [
        "wheel"
        "dialout"
        "tty"
      ]
      hashedPassword = "$y$j9T$MaXetZGv2P37gaHZcHlM30$XYGjeh42kWUD5UsosMo9KIm6pF8v7VGDAI6JTTVTFh.";
      openssh.authorizedKeys.keys = vars.sshPubKeys_Leo;
    }
    users.root = {
      openssh.authorizedKeys.keys = vars.sshPubKeys_Leo;
    }
  };

  services = {
  };

  programs = {
  };

}
