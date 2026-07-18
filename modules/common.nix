{
  config,
  lib,
  pkgs,
  ...
}:
{
  
  time.timeZone = "Europe/Berlin";

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
    firewall.checkReversePath = false;
    nftables.enable = true;
  };
  systemd.services.NetworkManager-wait-online.enable = true;
  
  security.rtkit.enable = true;

boot.kernelPackages = pkgs.linuxPackages_latest;
boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = lib.mkDefault true;
  
  boot = {
    kernel.sysctl."kernel.dmesg_restrict" = false;
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "fuse" ];
  };
    programs.fuse.userAllowOther = true;


  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };
    environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";


  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    ports = [
      22
      24
    ];
  };

  programs.ssh = {
    startAgent = true;
    enableAskPassword = true;
    askPassword = lib.getExe pkgs.kdePackages.ksshaskpass;
  };
  
  console.keyMap = lib.mkDefault "sk-qwerty";
  services.xserver.xkb = {
    layout = lib.mkDefault "sk";
    variant = lib.mkDefault "qwerty";
  };
  
  security.sudo.wheelNeedsPassword = false;
  
  environment.sessionVariables = {
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
    PATH = [ "$HOME/.local/bin" ];
    LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
  };

  
  i18n = {
    defaultLocale = lib.mkDefault "en_US.UTF-8";
    extraLocaleSettings = lib.mkDefault ( lib.genAttrs [
      "LC_ADDRESS"
      "LC_IDENTIFICATION"
      "LC_NAME"
      "LC_MEASUREMENT"
      "LC_NUMERIC"
      "LC_MONETARY"
      "LC_PAPER"
      "LC_TELEPHONE"
      "LC_TIME"
    ] (var: "sk_SK.UTF-8")
    );
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
  
  
    programs = {
    git.enable = true;

  };
}
