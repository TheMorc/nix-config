{ ... }:

{
  imports = [
    ./common.nix
    ../modules/packages-server.nix
  ];

  services = {
    xserver.enable = true;
    xserver.desktopManager.lxqt.enable = true;
    xserver.displayManager.lightdm.enable = true;
    printing.enable = true;
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  environment.sessionVariables.SSH_ASKPASS_REQUIRE = "prefer";

  networking.networkmanager.enable = true;

  # Required for WireGuard
  networking.firewall.checkReversePath = false;
}
