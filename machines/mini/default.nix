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
    inputs.apple-silicon-support.nixosModules.apple-silicon-support
  ];

  networking.hostName = "mini";

  nix.settings = {
    extra-substituters = [
      "https://nixos-apple-silicon.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nixos-apple-silicon.cachix.org-1:8psDu5SA5dAD7qA0zMy5UT292TxeEPzIz8VVEr2Js20="
    ];
  };

  boot.loader.efi.canTouchEfiVariables = false;
  
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;
  
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users.mini = ../../home/mini.nix;
  };

  hardware.firmware = [ inputs.dvbsky-firmware.packages.${pkgs.stdenv.hostPlatform.system}.default ];

  environment = {
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
      pgloader
      libmysqlclient

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
        "nginx"
      ]
      ++ lib.optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ lib.optionals config.programs.wireshark.enable [ "wireshark" ]
      ++ lib.optionals config.virtualisation.libvirtd.enable [ "libvirt" ];
      hashedPasswordFile = "/mini_local/hashedPassword";
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

    xserver = {

      videoDrivers = [ "modesetting" ];

      deviceSection = ''
        Option "AllowEmptyInitialConfiguration" "true"
      '';

      screenSection = ''
        SubSection "Display"
          Depth 24
          Virtual 1366 768
        EndSubSection
      '';
    };

    xserver.enable = true;
    xserver.desktopManager.lxqt.enable = true;
    xserver.displayManager.lightdm.enable = true;
    displayManager.autoLogin.user = "mini";
    displayManager.autoLogin.enable = true;
  };

  
 
  programs = {
    chromium.enable = true;

    firefox = {
      enable = true;
      preferences = {
        "widget.use-xdg-desktop-portal.file-picker" = 1;
      };
    };
  };

}
