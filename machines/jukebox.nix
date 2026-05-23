{
  pkgs,
  vars,
  lib,
  config,
  ...
}:

{

  imports = [
    ../modules/zsh.nix
  ];

  programs = {

    git.enable = true;

    ssh = {
      enableAskPassword = true;
    };
  };

  environment.systemPackages = with pkgs; [
    appimage-run
    bind
    curl
    dnsmasq
    fastfetch
    ffmpeg
    file
    killall
    p7zip
    pv
    python3
    ripgrep
    rsync
    sshpass
    sops
    unrar
    unzip
    zip
    zlib
    adw-gtk3

    mpv
    vlc
    rhythmbox
    cider-2
    yt-dlp
  ];

  services = {

    displayManager.autoLogin.enable = true;
    displayManager.autoLogin.user = "jukebox";

    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;

    printing.enable = false;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    gnome = {
      core-apps.enable = true;
      core-developer-tools.enable = false;
      games.enable = false;
      at-spi2-core.enable = true;
    };
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-music
    snapshot
    gnome-connections
    baobab
    gnome-contacts
    simple-scan
    gnome-tour
    gnome-user-docs
    gnome-maps
    gnome-logs
    gnome-clocks
    gnome-weather
    gnome-characters
    gnome-font-viewer
    gnome-disk-utility
    gnome-calendar
    gnome-calculator
    yelp
  ];

  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  networking.networkmanager.enable = true;

  # Required for WireGuard
  networking.firewall.checkReversePath = false;

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

  users = {
    mutableUsers = false;
    users.jukebox = {
      isNormalUser = true;
      description = "Jukebox user";
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
