{
  config,
  lib,
  pkgs,
  ...
}:
{

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "leandro@works-on-my.computer";
  };

  services.phpfpm.pools."www" = {
    user = "nginx";

    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
      "security.limit_extensions" = ".php .html";
    };

    phpOptions = ''
      memory_limit = 512M
      upload_max_filesize = 50000M;
      post_max_size = 50000M;
    '';
  };

  services.nginx.virtualHosts."works-on-my.computer" = {
    default = true;
    enableACME = true;
    forceSSL = false;

    serverAliases = [
      "leandro.funfeuro.net"
    ];

    root = "/tank/services/www";

    extraConfig = ''
      	client_body_buffer_size 50000M;
      	client_max_body_size 50000M;

      	location ~* \.(png|jpg|jpeg|gif)$ {
      		expires 365d;
      		add_header Cache-Control "public, no-transform";
      	}
      	location ~* \.(js|css|pdf|swf)$ {
      		expires 30d;
      		add_header Cache-Control "public, no-transform";
      	}

      	index index.html index.php;

      	gzip on;
      	gzip_vary on;
      	gzip_min_length 10240;
      	gzip_proxied expired no-cache no-store private auth;
      	gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml;
      	gzip_disable "MSIE [1-6]\.";

      	resolver 192.168.1.1 valid=300s;

          location ~ \.(php|html)$ {
            include ${config.services.nginx.package}/conf/fastcgi_params;

            fastcgi_pass  unix:${config.services.phpfpm.pools.www.socket};
            fastcgi_index index.php;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

            include ${pkgs.nginx}/conf/fastcgi.conf;

            fastcgi_read_timeout 300;
          }

    '';
  };

  services.nginx.appendHttpConfig = ''
    server {
        listen       443 ssl;
        listen       [::]:443 ssl;
        root         /mini_local/www;

        ssl_certificate "/var/lib/acme/works-on-my.computer/fullchain.pem";
        ssl_certificate_key "/var/lib/acme/works-on-my.computer/key.pem";
        ssl_session_cache shared:le_nginx_SSL:10m;
        ssl_session_timeout 1440m;
        ssl_session_tickets off;
        ssl_protocols SSLv2 SSLv3 TLSv1 TLSv1.2;
        ssl_ciphers ALL:eNULL:ADH:3DES:+RSA:@SECLEVEL=0;
        ssl_prefer_server_ciphers on;

        client_body_buffer_size 50000M;
        client_max_body_size 50000M;

        include /etc/nginx/default.d/*.conf;

        location ~* \.(png|jpg|jpeg|gif)$ {
            expires 365d;
            add_header Cache-Control "public, no-transform";
        }
        location ~* \.(js|css|pdf|swf)$ {
            expires 30d;
            add_header Cache-Control "public, no-transform";
        }

        index index.html index.php;

        location ~ \.(php|html)$ {
          include ${config.services.nginx.package}/conf/fastcgi_params;

            fastcgi_pass  unix:${config.services.phpfpm.pools.www.socket};
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

            include ${pkgs.nginx}/conf/fastcgi.conf;

            fastcgi_read_timeout 300;
        }

        gzip on;
        gzip_vary on;
        gzip_min_length 10240;
        gzip_proxied expired no-cache no-store private auth;
        gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml;
        gzip_disable "MSIE [1-6]\.";
    }
  '';

}
