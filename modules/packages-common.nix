{
  config,
  pkgs,
  inputs,
  ...
}:

let
  selfPkgs = inputs.self.packages.${pkgs.system};
in
{
  programs = {

    git.enable = true;
    htop.enable = true;
    ssh = {
      startAgent = true;
    };
  };

  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
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

  ];
}
