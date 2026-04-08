# David's Leo's Morc's NixOS configs
Configuration files for my NixOS machines, for my NixOS shenanigans.

## Machines
* **mini** - Mac mini M1 (aarch64-linux)
   - The main server in Biskupová

* **LatitudeE7270** - Dell Latitude E7270 (x86_64-linux)
   - The test environment for all other machines + throwaway 

## Universal installation:
1. Install NixOS, duhh...
2. Deploy:
    ```
    nix-shell -p git --run "git clone https://github.com/themorc/nix-config.git"
    cd nix-config
    sudo nixos-rebuild boot --flake "path:.#LatitudeE7270"
	```
3. Reboot:
	```
    sudo reboot
    ```
    
## Credits
* @leandrofriedrich for the kanged repo
* @ungeskriptet for all of the hints along the way
* God for the sanity
