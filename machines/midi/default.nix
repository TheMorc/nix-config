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

  networking = {
    hostName = "midi";
    interfaces.eno1 = {
      useDHCP = false;
      ipv4.addresses = [
        {
          address = "192.168.1.5";
          prefixLength = 24;
        }
      ];
    };

    defaultGateway = "192.168.1.1";
    nameservers = [
      "192.168.1.2"
      "8.8.8.8"
    ];
  };

  boot.loader.efi.canTouchEfiVariables = false;

  environment = {
    systemPackages = with pkgs; [
      fastfetch
      gh
      nh
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
      ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ lib.optionals config.programs.wireshark.enable [ "wireshark" ]
      ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirt" ];
      hashedPassword = "$y$j9T$MaXetZGv2P37gaHZcHlM30$XYGjeh42kWUD5UsosMo9KIm6pF8v7VGDAI6JTTVTFh.";
      openssh.authorizedKeys.keys = vars.sshPubKeys_Leo;
    }
    // lib.optionalAttrs config.programs.zsh.enable { shell = pkgs.zsh; };
    users.root = {
      openssh.authorizedKeys.keys = vars.sshPubKeys_Leo;
    }
    // lib.optionalAttrs config.programs.zsh.enable { shell = pkgs.zsh; };
  };

  services = {
  };

  programs = {
  };

}
