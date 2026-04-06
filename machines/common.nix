{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../modules/packages-common.nix
    ../modules/users.nix
    ../modules/virtualization.nix
    ../modules/zsh.nix
  ];

  boot.kernel.sysctl."kernel.dmesg_restrict" = false;
  boot.tmp.cleanOnBoot = true;
  boot.supportedFilesystems = [ "fuse" ];
  programs.fuse.userAllowOther = true;
  security.rtkit.enable = true;

  #home.file.".ssh/id_ed25519.pub".source = ../dot/id_ed25519.pub;

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    PATH = [ "$HOME/.local/bin" ];
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  time.timeZone = "Europe/Bratislava";
  console.keyMap = "sk-qwerty";

  services.xserver.xkb = {
    layout = "sk";
    variant = "qwerty";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = lib.genAttrs [
      "LC_ADDRESS"
      "LC_IDENTIFICATION"
      "LC_NAME"
      "LC_MEASUREMENT"
      "LC_NUMERIC"
      "LC_MONETARY"
      "LC_PAPER"
      "LC_TELEPHONE"
      "LC_TIME"
    ] (var: "sk_SK.UTF-8");
  };

  nix = {
    settings = {
      trusted-users = [ "@wheel" ];
      experimental-features = [
        "nix-command"
        "flakes"
      ];
    };
    gc.automatic = true;
    gc.dates = "weekly";
    gc.options = "-d";
  };
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";
}
