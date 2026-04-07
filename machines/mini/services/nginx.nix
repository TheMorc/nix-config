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
    defaults.email = "morc@370.network";
  };

  services.phpfpm.pools."www" = {
    user = "nobody";

    settings = {
      "pm" = "dynamic";
      "listen.owner" = config.services.nginx.user;
      "pm.max_children" = 5;
      "pm.start_servers" = 2;
      "pm.min_spare_servers" = 1;
      "pm.max_spare_servers" = 3;
      "pm.max_requests" = 500;
    };

    phpOptions = ''
      memory_limit = 512M
      upload_max_filesize = 50000M;
      post_max_size = 50000M;
    '';
  };

  #:80, :370
  services.nginx.virtualHosts."biskupova.televiziastb.sk" = {
    default = true;
    enableACME = true;
    forceSSL = false;

    serverAliases = [
      "biskupova.370.network"
      "biskupova.funfeuro.net"
      "176.101.178.133"
    ];

    extraConfig = ''
    listen       370;
    listen       [::]:370;

	client_body_buffer_size 50000M;
	client_max_body_size 50000M;

	error_page 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 421 422 423 424 425 426 428 429 431 451 500 501 502 503 504 505 506 507 508 510 511 /posralosato.html;
	location = /posralosato.html {
		ssi on;
		internal;
		auth_basic off;
		root /var/www/html;
	}

	location ~* \.(png|jpg|jpeg|gif)$ {
		expires 365d;
		add_header Cache-Control "public, no-transform";
	}
	location ~* \.(js|css|pdf|html|swf)$ {
		expires 30d;
		add_header Cache-Control "public, no-transform";
	}

	rewrite ^/\.well-known/(host-meta|webfinger).* https://fed.brid.gy$request_uri? redirect;

	gzip on;
	gzip_vary on;
	gzip_min_length 10240;
	gzip_proxied expired no-cache no-store private auth;
	gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml;
	gzip_disable "MSIE [1-6]\.";

	resolver 192.168.1.1 valid=300s;

	location ~ ^/live_joj/(.*)$ {
        set $filename $1;
		set $upstream_base https://live.cdn.joj.sk/live/andromeda/;

		proxy_pass $upstream_base$filename;
        proxy_set_header Referer "$upstream_base$filename";

		sub_filter_types application/vnd.apple.mpegurl text/plain;
        sub_filter_once off;
		sub_filter 'joj' 'https://live.cdn.joj.sk/live/andromeda/joj';

		gunzip on;
        gzip off;
    }

    location ~ \.php$ {

      fastcgi_pass  unix:${config.services.phpfpm.pools.www.socket};
      fastcgi_index index.php;
      fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

      fastcgi_read_timeout 300;
    }

    '';
  };

  #custom 443 with crazy ssl
  services.nginx.appendHttpConfig = ''
    server {
        listen       443 ssl;
        listen       [::]:443 ssl;
        root         /var/www/html/;

        ssl_certificate "/var/lib/acme/biskupova.televiziastb.sk/fullchain.pem";
        ssl_certificate_key "/var/lib/acme/biskupova.televiziastb.sk/key.pem";
        ssl_session_cache shared:le_nginx_SSL:10m;
        ssl_session_timeout 1440m;
        ssl_session_tickets off;
        ssl_protocols SSLv2 SSLv3 TLSv1 TLSv1.2;
        ssl_ciphers ALL:eNULL:ADH:3DES:+RSA:@SECLEVEL=0;
        ssl_prefer_server_ciphers on;

        client_body_buffer_size 50000M;
        client_max_body_size 50000M;

        include /etc/nginx/default.d/*.conf;

        error_page 400 401 402 403 404 405 406 407 408 409 410 411 412 413 414 415 416 417 418 421 422 423 424 425 426 428 429 431 451 500 501 502 503 504 505 506 507 508 510 511 /posralosato.html;
        location = /posralosato.html {
            ssi on;
            internal;
            auth_basic off;
            root /var/www/html;
        }

        location ~* \.(png|jpg|jpeg|gif)$ {
            expires 365d;
            add_header Cache-Control "public, no-transform";
        }
        location ~* \.(js|css|pdf|html|swf)$ {
            expires 30d;
            add_header Cache-Control "public, no-transform";
        }

        location ~ \.php$ {

          fastcgi_pass  unix:${config.services.phpfpm.pools.www.socket};
          fastcgi_index index.php;
          fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;

          fastcgi_read_timeout 300;
        }

        rewrite ^/\.well-known/(host-meta|webfinger).* https://fed.brid.gy$request_uri? redirect;

        gzip on;
        gzip_vary on;
        gzip_min_length 10240;
        gzip_proxied expired no-cache no-store private auth;
        gzip_types text/plain text/css text/xml text/javascript application/x-javascript application/xml;
        gzip_disable "MSIE [1-6]\.";
    }
    '';

    services.nginx.virtualHosts."homeassistant" = {
      enableACME = false;
      forceSSL = true;

      http2 = true;

      listen = [
        { addr = "0.0.0.0"; port = 371; ssl = true; }
        { addr = "[::]"; port = 371; ssl = true; }
      ];

      sslCertificate = "/var/lib/acme/biskupova.televiziastb.sk/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/biskupova.televiziastb.sk/key.pem";

      extraConfig = ''
        client_max_body_size 50000M;
        access_log off;
        proxy_buffering off;
      '';

      locations."/" = {
        proxyPass = "http://[::1]:8123";
        proxyWebsockets = true;
      };

    };

    services.nginx.virtualHosts."immich" = {
      enableACME = false;
      forceSSL = true;

      http2 = true;

      listen = [
        { addr = "0.0.0.0"; port = 372; ssl = true; }
        { addr = "[::]"; port = 372; ssl = true; }
      ];

      sslCertificate = "/var/lib/acme/biskupova.televiziastb.sk/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/biskupova.televiziastb.sk/key.pem";

      extraConfig = ''
        client_max_body_size 50000M;
        access_log off;
      '';

      locations."/" = {
        proxyPass = "http://localhost:2283";
        proxyWebsockets = true;

        extraConfig = ''
          proxy_set_header Host              $host;
          proxy_set_header X-Real-IP         $remote_addr;
          proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

    services.nginx.virtualHosts."cockpit" = {
      enableACME = false;
      forceSSL = true;

      http2 = true;

      listen = [
        { addr = "0.0.0.0"; port = 373; ssl = true; }
        { addr = "[::]"; port = 373; ssl = true; }
      ];

      sslCertificate = "/var/lib/acme/biskupova.televiziastb.sk/fullchain.pem";
      sslCertificateKey = "/var/lib/acme/biskupova.televiziastb.sk/key.pem";

      extraConfig = ''
        client_max_body_size 50000M;
        access_log off;
      '';

      locations."/" = {
        proxyPass = "http://localhost:9090";
        proxyWebsockets = true;

        extraConfig = ''
          proxy_set_header Host              $host;
          proxy_set_header X-Real-IP         $remote_addr;
          proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
          proxy_set_header X-Forwarded-Proto $scheme;
        '';
      };
    };

}
