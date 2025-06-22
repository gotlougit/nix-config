{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.tokidoki;
  tokidoki = pkgs.callPackage ./tokidoki.nix { };

in {
  options.services.tokidoki = {
    enable = mkEnableOption "tokidoki CalDAV/CardDAV server";

    package = mkOption {
      type = types.package;
      default = tokidoki;
      defaultText = literalExpression "pkgs.tokidoki";
      description = "The tokidoki package to use.";
    };

    address = mkOption {
      type = types.str;
      default = "127.0.0.1";
      description =
        "Address to bind to. Use 0.0.0.0 to bind to all interfaces.";
    };

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "Port to listen on.";
    };

    openFirewall = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to open the firewall for the specified port.";
    };

    authUrl = mkOption {
      type = types.str;
      example = "pam://";
      description = ''
        Authentication backend URL. Examples:
        - "pam://" for PAM authentication
        - "imaps://imap.example.com:993" for IMAP authentication
        - "file:///path/to/htpasswd" for htpasswd file authentication
      '';
    };

    storageUrl = mkOption {
      type = types.str;
      default = "file:///var/lib/private/tokidoki/storage";
      description = ''
        Storage backend URL. Examples:
        - "file:///path/to/storage" for filesystem storage
        - "postgresql://user:pass@host/db" for PostgreSQL storage
      '';
    };

    storageDir = mkOption {
      type = types.path;
      default = "/var/lib/private/tokidoki/storage";
      description =
        "Directory for filesystem storage (when using file:// storage backend).";
    };

    tls = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable TLS.";
      };

      certificateFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to the TLS certificate file.";
      };

      keyFile = mkOption {
        type = types.nullOr types.path;
        default = null;
        description = "Path to the TLS private key file.";
      };
    };

    logging = {
      debug = mkOption {
        type = types.bool;
        default = false;
        description = "Enable debug logging.";
      };

      json = mkOption {
        type = types.bool;
        default = true;
        description = "Enable structured JSON logging.";
      };
    };

    extraArgs = mkOption {
      type = types.listOf types.str;
      default = [ ];
      description = "Additional command line arguments to pass to tokidoki.";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      networking.firewall.allowedTCPPorts = mkIf cfg.openFirewall [ cfg.port ];

      systemd.services.tokidoki = {
        description = "Tokidoki CalDAV/CardDAV Server";
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];

        serviceConfig = {
          Type = "simple";
          DynamicUser = true;
          StateDirectory = "tokidoki";
          UMask = "0077";

          ExecStart = let
            args = [
              "-addr"
              "${cfg.address}:${toString cfg.port}"
              "-auth.url"
              cfg.authUrl
              "-storage.url"
              cfg.storageUrl
            ] ++ optionals cfg.tls.enable [
              "-cert"
              cfg.tls.certificateFile
              "-key"
              cfg.tls.keyFile
            ] ++ optionals cfg.logging.debug [ "-log.debug" ]
              ++ optionals cfg.logging.json [ "-log.json" ] ++ cfg.extraArgs;
          in "${cfg.package}/bin/tokidoki ${escapeShellArgs args}";

          Restart = "always";
          RestartSec = "10s";

          # Security hardening
          NoNewPrivileges = true;
          PrivateDevices = true;
          PrivateTmp = true;
          ProtectSystem = "strict";
          ProtectHome = true;
          ProtectKernelTunables = true;
          ProtectKernelModules = true;
          ProtectKernelLogs = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          RestrictSUIDSGID = true;
          RestrictRealtime = true;
          RestrictNamespaces = true;
          LockPersonality = true;
          MemoryDenyWriteExecute = true;
          RemoveIPC = true;

          # Allow binding to ports
          AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
          CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];

          # Network restrictions
          RestrictAddressFamilies = [ "AF_INET" "AF_INET6" "AF_UNIX" ];

          # System call filtering
          SystemCallFilter = [
            "@system-service"
            "~@debug"
            "~@mount"
            "~@reboot"
            "~@swap"
            "~@privileged"
            "~@resources"
          ];

          # Additional paths for TLS certificates
          ReadOnlyPaths =
            mkIf cfg.tls.enable [ cfg.tls.certificateFile cfg.tls.keyFile ];

          # PAM access when using PAM authentication
          SupplementaryGroups =
            mkIf (hasPrefix "pam://" cfg.authUrl) [ "shadow" ];

          # Environment
          Environment = [ "TOKIDOKI_STORAGE_DIR=${cfg.storageDir}" ];
          ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${cfg.storageDir}";
        };
      };

    }

    {
      assertions = [
        {
          assertion = cfg.authUrl != "";
          message = "services.tokidoki.authUrl must be specified";
        }
        {
          assertion = cfg.storageUrl != "";
          message = "services.tokidoki.storageUrl must be specified";
        }
        {
          assertion = cfg.tls.enable
            -> (cfg.tls.certificateFile != null && cfg.tls.keyFile != null);
          message =
            "services.tokidoki.tls.certificateFile and services.tokidoki.tls.keyFile must both be specified when TLS is enabled";
        }
        {
          assertion = !cfg.tls.enable
            -> (cfg.tls.certificateFile == null && cfg.tls.keyFile == null);
          message =
            "services.tokidoki.tls.certificateFile and services.tokidoki.tls.keyFile should not be specified when TLS is disabled";
        }
      ];
    }
  ]);
}
