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
    ../modules/virtualization.nix
    ../modules/zsh.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.mini = ../home/mini.nix;
  };

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";

  hardware.firmware = [ inputs.dvbsky-firmware.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  environment = {

    sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

    systemPackages = with pkgs; [
      android-tools
      appimage-run
      autoconf
      automake
      bind
      binutils
      binwalk
      cmake
      curl
      dig
      dnsmasq
      dtc
      fastfetch
      ffmpeg
      file
      gcc
      gdb
      gh
      gnumake
      inetutils
      internetarchive
      killall
      meson
      ncdu
      ninja
      nmap
      p7zip
      pciutils
      picocom
      pkg-config
      pv
      python3
      ripgrep
      rsync
      sshpass
      sops
      sturmflut
      tmate
      tmux
      unrar
      unzip
      usbutils
      v4l-utils
      zip
      zlib
      wget

      milkytracker
      obs-studio
      tree
      mpv
      yt-dlp
      kdePackages.kate
      kdePackages.konsole
      chromium
      conky
      netsurf-browser
      classicube
      inputs.cpupercent.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    lxqt.excludePackages = with pkgs; [
      lxqt.qterminal
      lxqt.qlipper
      xscreensaver
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
    users.mini = {
      isNormalUser = true;
      description = "Mac mini Server";
      extraGroups = [
        "wheel"
        "dialout"
        "tty"
        "hass"
        "immich"
        "transmission"
        "jellyfin"
        "mcgalaxy"
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

  services = {
    usbmuxd.enable = true;
    flatpak.enable = true;

    xserver.xkb = {
      layout = "sk";
      variant = "qwerty";
    };

    xserver.enable = true;
    xserver.desktopManager.lxqt.enable = true;
    xserver.displayManager.lightdm.enable = true;
    displayManager.autoLogin.user = "mini";
    displayManager.autoLogin.enable = true;
  };

  time.timeZone = "Europe/Bratislava";
  console.keyMap = "sk-qwerty";

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

  programs = {
    git.enable = true;
    htop.enable = true;

    fuse.userAllowOther = true;

    chromium.enable = true;

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
  };

  systemd.services.NetworkManager-wait-online.enable = true;

}
