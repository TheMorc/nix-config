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
    ../modules/zsh.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.htpc = ../home/bigscreen.nix;
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";

  environment = {

    sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

    systemPackages = with pkgs; [
      fastfetch
      wget
      gh
      unzip
      androidenv.androidPkgs.platform-tools

      inputs.self.packages.${pkgs.stdenv.hostPlatform.system}.plasma-bigscreen
      jellyfin-desktop
    ];

    sessionVariables = {
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_STATE_HOME = "$HOME/.local/state";
      PATH = [ "$HOME/.local/bin" ];
      LD_LIBRARY_PATH = "${pkgs.stdenv.cc.cc.lib}/lib";
    };

  };

  boot = {
    kernel.sysctl."kernel.dmesg_restrict" = false;
    tmp.cleanOnBoot = true;
    supportedFilesystems = [ "fuse" ];
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

  time.timeZone = "Europe/Bratislava";
  console.keyMap = "sk-qwerty";

  i18n = {
    defaultLocale = "sk_SK.UTF-8";
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

  programs = {
    git.enable = true;
    htop.enable = true;

    fuse.userAllowOther = true;

    firefox = {
      enable = true;
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };

  networking = {
    firewall.enable = false;
    networkmanager.enable = true;
    firewall.checkReversePath = false;
    nftables.enable = true;
  };

  systemd.services.NetworkManager-wait-online.enable = true;

}
