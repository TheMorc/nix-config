# David's Leo's Morc's NixOS configs
Configuration files for my NixOS machines, for my NixOS shenanigans.

## Machines
* **KankerPad** - Lenovo ThinkPad L15 Gen1 ***(x86_64-linux)***
   - Leo's e-waste laptop

* **mini** - Mac mini M1 ***(aarch64-linux)***
   - The main server in Biskupová

* **midi** - HP EliteDesk 705 G4 MT ***(x86_64-linux)***
   - Leo's main PVE+NixOS server

* **LatitudeE7270** - Dell Latitude E7270 ***(x86_64-linux)***
   - The test environment for all other machines + throwaway laptop without a battery these days

* **bigscreen** - HP ProDesk 600 G2 Desktop Mini ***(x86_64-linux)***
   - Basement HTPC running KDE Plasma Bigscreen + Waydroid for Android apps on a plasma TV

* **jukebox** - ASUS ET1620i AiO ***(x86_64-linux)***
   - Basement "audio jukebox" with Apple Music, internet radios and local libraries


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
* [@leandrofriedrich](https://github.com/leandrofriedrich) for the kanged repo
* [@ungeskriptet](https://github.com/ungeskriptet) for all of the hints along the way
* God for the sanity
