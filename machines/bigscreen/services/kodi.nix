{
  config,
  pkgs,
  inputs,
  ...
}:
{

  nixpkgs.config.kodi.enableAdvancedLauncher = true;


    environment.systemPackages = [
     (pkgs.kodi.withPackages (kodiPkgs: with kodiPkgs; [
		pvr-hts
      ]))
  ];



}
