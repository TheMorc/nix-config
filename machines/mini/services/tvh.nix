# kudos to ungeskriptet
{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [ ../../../packages/tvh.nix ];
  services.tvheadend2 = {
    enable = true;
    firstRun = true;
    dataDir = "/mini_local/tvheadend/";
    package = inputs.tvh.legacyPackages.${pkgs.stdenv.hostPlatform.system}.tvheadend;
  };
}
