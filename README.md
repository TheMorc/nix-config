# David's Leo's Morc's NixOS configs
Configuration files for my NixOS machines.

## TEST TEST TEST TEST
TEST COPNUTER

### Installation:
1. Install NixOS, duhh...
2. Deploy:
    ```
    nix-shell -p git --run "git clone https://github.com/themorc/nix-config.git"
    cd nix-config
    sudo nixos-rebuild boot --flake "path:.#KankerPad"
	```
3. Reboot:
	```
    sudo reboot
    ```
