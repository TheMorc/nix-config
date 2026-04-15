{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.logind = {
    powerKey = "ignore";
    powerKeyLongPress = "ignore";
    suspendKey = "ignore";
    suspendKeyLongPress = "ignore";
    hibernateKey = "ignore";
    hibernateKeyLongPress = "ignore";
  };

  services.udev.extraHwdb = ''
    evdev:name:MemsArt MA144 RF Controller System Control:*
      KEYBOARD_KEY_10081=f13
  '';

  services.keyd = {
      enable = true;
      keyboards = {
        default = {
          ids = [ "*" ];
          settings = {
            main = {
              "back" = "esc";
              "homepage" = "macro(homepage f24)";
            };
          };
        };
      };
    };  

}
