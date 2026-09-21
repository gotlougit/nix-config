{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.services.kittygram;
in
{
  options.services.kittygram = {
    enable = lib.mkEnableOption "Kittygram Instagram frontend";

    package = lib.mkPackageOption pkgs "kittygram" { };

    address = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Address the embedded nginx server listens on.";
    };

    port = lib.mkOption {
      type = lib.types.port;
      default = 8095;
      description = "Port the embedded nginx server listens on.";
    };

    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to open the firewall for the configured port.";
    };

    resolver = lib.mkOption {
      type = lib.types.str;
      default = "1.1.1.1";
      description = "DNS resolver used by nginx for outbound HTTP requests.";
    };

    defaultTheme = lib.mkOption {
      type = lib.types.str;
      default = "auto";
      description = "Default theme of the web interface.";
    };

    aboutMessage = lib.mkOption {
      type = lib.types.str;
      default = "The operator of this instance has not written an about message yet.";
      description = "HTML about message displayed on the homepage.";
    };

    requireApiToken = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether an API token is required to use the API.";
    };

    numWorkers = lib.mkOption {
      type = lib.types.ints.positive;
      default = 4;
      description = "Number of nginx worker processes.";
    };

    redisCreateLocally = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to create a local Redis instance used for caching.";
    };

    redisHost = lib.mkOption {
      type = lib.types.str;
      default = "127.0.0.1";
      description = "Host of the Redis instance used for caching.";
    };

    redisPort = lib.mkOption {
      type = lib.types.port;
      default = 6380;
      description = "Port of the Redis instance used for caching.";
    };

    secret = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = ''
        Secret used to sign tokens. When left as null a random secret is
        generated and persisted on first start.
      '';
    };

    environmentFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Additional environment file passed to the service.";
    };

    settings = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = { };
      description = "Additional environment variables for the service.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.redis.servers.kittygram = lib.mkIf cfg.redisCreateLocally {
      enable = true;
      bind = "127.0.0.1";
      port = cfg.redisPort;
    };

    systemd.services.kittygram = {
      description = "Kittygram Instagram frontend";
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ] ++ lib.optional cfg.redisCreateLocally "redis-kittygram.service";
      requires = lib.optional cfg.redisCreateLocally "redis-kittygram.service";

      path = [ pkgs.coreutils ];

      environment = {
        PORT = toString cfg.port;
        REDIS_HOST = cfg.redisHost;
        REDIS_PORT = toString cfg.redisPort;
        RESOLVER = cfg.resolver;
        DEFAULT_THEME = cfg.defaultTheme;
        ABOUT_MESSAGE = cfg.aboutMessage;
        REQUIRE_API_TOKEN = lib.boolToString cfg.requireApiToken;
        NUM_WORKERS = toString cfg.numWorkers;
        LAPIS_ADDRESS = cfg.address;
      } // cfg.settings;

      script = ''
        set -euo pipefail

        appdir="$STATE_DIRECTORY"
        cd "$appdir"

        # Link the application files from the read-only package into the state
        # directory. Only generated/mutable files (the SQLite database, the
        # compiled nginx configuration and logs) are kept in place across
        # restarts.
        for entry in ${cfg.package}/share/kittygram/*; do
          name="$(basename "$entry")"
          case "$name" in
            kittygram.sqlite | nginx.conf.compiled | logs) continue ;;
          esac
          rm -rf -- "$name"
          ln -s "$entry" "$name"
        done

        # Persist a token signing secret across restarts.
        if [ ! -s .secret ]; then
          umask 077
          head -c 32 /dev/urandom | base64 > .secret
        fi
        export SECRET="$(cat .secret)"
        ${lib.optionalString (cfg.secret != null) ''
          export SECRET=${lib.escapeShellArg cfg.secret}
        ''}

        ${cfg.package}/bin/kittygram-migrate docker
        exec ${cfg.package}/bin/kittygram docker
      '';

      serviceConfig = {
        Type = "simple";
        DynamicUser = true;
        StateDirectory = "kittygram";
        StateDirectoryMode = "0700";
        EnvironmentFile = lib.mkIf (cfg.environmentFile != null) cfg.environmentFile;

        Restart = "always";
        RestartSec = "5s";

        # nginx/openresty hardening, closely modelled on the upstream redlib
        # module. Note that LuaJIT needs writable+executable memory, so
        # MemoryDenyWriteExecute must stay disabled.
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        PrivateIPC = true;
        PrivateTmp = true;
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = true;
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "invisible";
        ProtectSystem = "strict";
        RemoveIPC = true;
        RestrictAddressFamilies = [
          "AF_INET"
          "AF_INET6"
        ];
        RestrictNamespaces = true;
        RestrictRealtime = true;
        RestrictSUIDSGID = true;
        SystemCallArchitectures = "native";
        SystemCallFilter = [
          "@system-service"
          "~@clock"
          "~@cpu-emulation"
          "~@debug"
          "~@keyring"
          "~@memlock"
          "~@module"
          "~@mount"
          "~@obsolete"
          "~@privileged"
          "~@raw-io"
          "~@reboot"
          "~@resources"
          "~@setuid"
          "~@swap"
        ];
        UMask = "0027";
      }
      // (
        if cfg.port < 1024 then
          {
            AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
            CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
          }
        else
          {
            # A private user cannot have process capabilities on the host's
            # user namespace, so drop everything when binding an unprivileged
            # port.
            PrivateUsers = true;
            CapabilityBoundingSet = [ ];
          }
      );
    };

    networking.firewall.allowedTCPPorts = lib.mkIf cfg.openFirewall [ cfg.port ];
  };
}