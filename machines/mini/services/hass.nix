{
  config,
  lib,
  pkgs,
  ...
}:
{
  #homeassistant group workaround
  system.activationScripts.homeassistantWorkaround = ''
    mkdir -p /mini_local/homeassistant/
    chown hass:hass -R /mini_local/homeassistant/.
    chmod 770 -R /mini_local/homeassistant/
  '';

  services.home-assistant = {
    enable = true;
    configDir = "/mini_local/homeassistant/";
    extraComponents = [
      # Components required to complete the onboarding
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      # Recommended for fast zlib compression
      # https://www.home-assistant.io/integrations/isal
      "isal"
    ];
    config = {
      # Includes dependencies for a basic setup
      # https://www.home-assistant.io/integrations/default_config/
      default_config = { };
    };
    extraPackages = ps: with ps; [ psycopg2 ];
    config.recorder.db_url = "postgresql://@/hass";
  };

  services.home-assistant.config.http = {
    server_host = "::1";
    trusted_proxies = [ "::1" ];
    use_x_forwarded_for = true;
  };
}
