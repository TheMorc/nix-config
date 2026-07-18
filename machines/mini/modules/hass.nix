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
      "analytics"
      "google_translate"
      "met"
      "radio_browser"
      "shopping_list"
      "isal"
      "recorder"
      "usage_prediction"
      "history"
      "energy"
      "logbook"
      "sonos"
      "samsungtv"
      "androidtv_remote"
      "yeelight"
      "cast"
      "wled"
      "tuya"
      "upnp"
      "apple_tv"
      "homekit"
      "homekit_controller"
      "esphome"
      "bluetooth_adapters"
      "xiaomi_ble"
      "default_config"
      "rflink"
      "zha"
      "opnsense"
    ];
    customComponents = with pkgs.home-assistant-custom-components; [
      midea_ac_lan
      tuya_local
    ];
    config = {
      default_config = { };

      frontend = {
        themes = "!include_dir_merge_named themes";
      };

      automation = "!include automations.yaml";
      script = "!include scripts.yaml";
      scene = "!include scenes.yaml";

      device_tracker = [
        {
          platform = "bluetooth_le_tracker";
          track_new_devices = false;
        }
      ];

      rflink = {
        port = "/dev/serial/by-id/usb-Arduino__www.arduino.cc__Arduino_Mega_2560_12254501101131795664-if00";
      };

      switch = [
        {
          platform = "rflink";
          devices = {
            unitec_1804_01 = { };
            unitec_1804_02 = { };
            unitec_1804_03 = { };
            unitec_1804_04 = { };
          };
        }
      ];

      light = [
        {
          platform = "rflink";
          automatic_add = false;
        }
      ];

      sensor = [
        {
          platform = "rflink";
          devices = {
            cresta_3601_temp = {
              sensor_type = "temperature";
            };
            cresta_3601_hum = {
              sensor_type = "humidity";
            };
          };
          automatic_add = false;
        }
      ];

      mqtt = {
        sensor = [
          {
            state_topic = "cheerlightsRGB";
            name = "CheerLights Farba";
          }
        ];
      };

      rest_command = {
        cam_night = {
          url = "http://root:1234@192.168.1.4/night/on";
        };
        cam_day = {
          url = "http://root:1234@192.168.1.4/night/off";
        };
      };

      zha = {
        enable_quirks = true;
        custom_quirks_path = "zha_quirks";
      };

    };
    #extraPackages = ps: with ps; [ psycopg2 ];
    #config.recorder.db_url = "postgresql://@/hass";
  };

  services.home-assistant.config.http = {
    server_host = "::1";
    trusted_proxies = [ "::1" ];
    use_x_forwarded_for = true;
  };

}
