{
  config,
  inputs,
  lib,
  pkgs,
  vars,
  ...
}:

{
  users = {
    mutableUsers = false;
    users.richardgracik = {
      isNormalUser = true;
      description = "Richard Gráčik";
      extraGroups = [
        "wheel"
        "dialout"
        "tty"
      ]
      ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ lib.optionals config.programs.wireshark.enable [ "wireshark" ]
      ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirt" ];
      hashedPassword = "$y$j9T$MaXetZGv2P37gaHZcHlM30$XYGjeh42kWUD5UsosMo9KIm6pF8v7VGDAI6JTTVTFh.";
      openssh.authorizedKeys.keys = vars.sshPubKeys;
    }
    // lib.optionalAttrs config.programs.zsh.enable { shell = pkgs.zsh; };
    users.root = {
      openssh.authorizedKeys.keys = vars.sshPubKeys;
    }
    // lib.optionalAttrs config.programs.zsh.enable { shell = pkgs.zsh; };
  };

}
