{
  lib,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ../modules/users.nix
    ../modules/virtualization.nix
    ../modules/zsh.nix
  ];

  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";

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
      tailscale
      tmate
      tmux
      unrar
      unzip
      usbutils
      v4l-utils
      zip
      zlib

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

  security.rtkit.enable = true;

  #home.file.".ssh/id_ed25519.pub".source = ../dot/id_ed25519.pub;

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
    printing.enable = true;
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
    networking.networkmanager.enable = true;
    networking.firewall.checkReversePath = false;
  };

}
