{
  inputs,
  pkgs,
  lib,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    ./modules
  ];

  networking.hostName = "jukebox";

  boot.kernelParams = [ "intel_idle.max_cstate=1" ];
  boot.loader.systemd-boot.consoleMode = "max";

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

}
