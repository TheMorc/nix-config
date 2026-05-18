{ pkgs, ... }:

{
  imports = [
    ./common.nix
    ../modules/packages-desktop.nix
  ];

  services = {
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
    };
  };

  environment.gnome.excludePackages = with pkgs; [ gnome-tour gnome-user-docs ];

  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  networking.networkmanager.enable = true;

  # Required for WireGuard
  networking.firewall.checkReversePath = false;
}
