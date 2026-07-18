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
    inputs.home-manager.nixosModules.home-manager
  ];
  

  networking.hostName = "bigscreen";

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.efi.canTouchEfiVariables = true;
  

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.htpc = ../home/bigscreen.nix;
  };


  environment = {

    systemPackages = with pkgs; [
      fastfetch
      wget
      gh
      unzip
      androidenv.androidPkgs.platform-tools
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.bigscreen_curtain
      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.plasma-bigscreen
      jellyfin-desktop
    ];

  };

  users = {
    mutableUsers = false;
    users.htpc = {
      isNormalUser = true;
      description = "HTPC user";
      extraGroups = [
        "wheel"
        "dialout"
        "tty"
      ]
      ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ];
      hashedPassword = "$y$j9T$MaXetZGv2P37gaHZcHlM30$XYGjeh42kWUD5UsosMo9KIm6pF8v7VGDAI6JTTVTFh.";
      openssh.authorizedKeys.keys = vars.sshPubKeys;
    }
    // lib.optionalAttrs config.programs.zsh.enable { shell = pkgs.zsh; };
    users.root = {
      openssh.authorizedKeys.keys = vars.sshPubKeys;
    }
    // lib.optionalAttrs config.programs.zsh.enable { shell = pkgs.zsh; };
  };

  services = {
    usbmuxd.enable = true;
    flatpak.enable = true;

    xserver.xkb = {
      layout = "sk";
      variant = "qwerty";
    };

    desktopManager.plasma6.enable = true;
    displayManager = {
      sddm.enable = true;
      autoLogin.user = "htpc";
      autoLogin.enable = true;
      sessionPackages = [ inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.plasma-bigscreen ];
      defaultSession = "plasma-bigscreen-wayland";
    };
  };

  environment.plasma6.excludePackages = with pkgs; [
    kdePackages.qrca
    kdePackages.okular
    kdePackages.elisa
    kdePackages.discover
    kdePackages.gwenview
  ];

  xdg.portal.configPackages = [
    inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.plasma-bigscreen
  ];

  programs = {
    htop.enable = true;

    firefox = {
      enable = true;
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };

}
