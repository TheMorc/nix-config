{ config, pkgs, ... }:

{
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "end0";
  };

  containers.internetarchive = {
    autoStart = false;
    privateNetwork = true;
    hostAddress = "192.168.0.1";
    localAddress = "192.168.0.2";

    bindMounts = {
      "/root" = {
        hostPath = "/mini_enterprise/archive.org";
        isReadOnly = false;
      };
    };

    allowedDevices = [
      {
        node = "/dev/net/tun";
        modifier = "rwm";
      }
    ];

    config = { pkgs, ... }: {
      services.tailscale.enable = true;
      networking.firewall.enable = false;

      programs.bash.promptInit = ''
        	if [ -z "$TMUX" ] && [ -n "$PS1" ]; then
                  	exec tmux new-session -A -s main
                fi
        	if [ -n "$TMUX" ]; then
        		source /root/ia_venv/bin/activate
              	fi
      '';

      environment.systemPackages = with pkgs; [
        python3
        python3Packages.pip
        tmux
      ];
    };
  };
}
