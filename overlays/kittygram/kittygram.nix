# Kittygram: a privacy-friendly, lightweight Instagram frontend (Nitter-like)
# built on OpenResty + Lapis.
#
# Kittygram needs a handful of LuaRocks that are not packaged in nixpkgs
# (lapis, lapis-redis, lua-resty-redis, htmlparser, date, pgmoon), so we add
# them to a private `luajit_openresty` package set and build the application
# against the resulting Lua environment.
{
  lib,
  stdenv,
  fetchgit,
  fetchurl,
  luajit_openresty,
  openresty,
  makeWrapper,
  cacert,
}:

let
  luaOverrides =
    final: prev:
    {
      date = final.buildLuarocksPackage {
        pname = "date";
        version = "2.2.1-2";
        knownRockspec = (fetchurl {
          url = "mirror://luarocks/date-2.2.1-2.rockspec";
          hash = "sha256-irEn/PoSZXgp1BXf3Qw6VtEDnFjE3hjX51M22IxOhkg=";
        }).outPath;
        src = fetchgit {
          url = "https://github.com/Tieske/date";
          rev = "2be47e4bca392c542509ac55d33d64bd60fc9402";
          hash = "sha256-P+blk1/M8hc9rWkF4UTDEoRZQPUY3XNmgXuF9Pes2KI=";
        };
        meta = {
          homepage = "https://github.com/Tieske/date";
          description = "Date & Time module for Lua 5.x";
          license = lib.licenses.mit;
        };
      };

      pgmoon = final.buildLuarocksPackage {
        pname = "pgmoon";
        version = "1.18.0-1";
        knownRockspec = (fetchurl {
          url = "mirror://luarocks/pgmoon-1.18.0-1.rockspec";
          hash = "sha256-fQzygYSiZCFVXlg6nTF59eRqSYHVi1M0L6ZBdGCE6vQ=";
        }).outPath;
        src = fetchgit {
          url = "https://github.com/leafo/pgmoon";
          rev = "240ff4fd58c9e68ed975a5a84ac01efc3094e98e";
          hash = "sha256-PofIvPRLtgTP8mNsatBLz6RjS2zxEDetoSfPo+qix9c=";
        };
        propagatedBuildInputs = [ final.lpeg ];
        meta = {
          homepage = "https://github.com/leafo/pgmoon";
          description = "Postgres driver for OpenResty and Lua";
          license = lib.licenses.mit;
        };
      };

      lapis = final.buildLuarocksPackage {
        pname = "lapis";
        version = "1.19.0-1";
        knownRockspec = (fetchurl {
          url = "mirror://luarocks/lapis-1.19.0-1.rockspec";
          hash = "sha256-BazIlyqd+qfH/gy9YPDSfBUp8G9QPwBVydtcPbkirck=";
        }).outPath;
        src = fetchgit {
          url = "https://github.com/leafo/lapis";
          rev = "10b2d62c186e34d8f8e54222b49e7f07151998ef";
          hash = "sha256-pjiKaVGPNPER3uRis5h+j1EIO0N5wD5VrAvDm/6nd2Y=";
        };
        propagatedBuildInputs = with final; [
          ansicolors
          argparse
          date
          etlua
          loadkit
          lpeg
          lua-cjson
          luaossl
          luasocket
          pgmoon
        ];
        meta = {
          homepage = "https://leafo.net/lapis";
          description = "A web framework for Lua/MoonScript";
          license = lib.licenses.mit;
        };
      };

      lua-resty-redis = final.buildLuarocksPackage {
        pname = "lua-resty-redis";
        version = "0.27-0";
        knownRockspec = (fetchurl {
          url = "mirror://luarocks/lua-resty-redis-0.27-0.rockspec";
          hash = "sha256-HTCnTWUqQM3fhlBwTrwZYCJeCv3ESkuB0210jHhlGMM=";
        }).outPath;
        src = fetchgit {
          url = "https://github.com/openresty/lua-resty-redis";
          rev = "4db1e96622baa1f761b2409e1b45f85e48622d82";
          hash = "sha256-xn3f4f2djrWD5Yu9Ab20rO/Jcqd2hxGWXn0MaHZBjmU=";
        };
        meta = {
          homepage = "https://github.com/openresty/lua-resty-redis";
          description = "Lua redis client driver for ngx_lua based on the cosocket API";
          license = lib.licenses.bsd2;
        };
      };

      lapis-redis = final.buildLuarocksPackage {
        pname = "lapis-redis";
        version = "1.0.0-1";
        knownRockspec = (fetchurl {
          url = "mirror://luarocks/lapis-redis-1.0.0-1.rockspec";
          hash = "sha256-GE4LVlob0ipJPHEujC83K3tO6PAOJXUnITnnGMb64EA=";
        }).outPath;
        src = fetchgit {
          url = "https://github.com/leafo/lapis-redis";
          rev = "e9299be140d41f4df1a9d5f7033bc1a4745b192b";
          hash = "sha256-sMQ0WK1e18Hrg2HVInLGsAThEiG+Fri/QxYLVyWcnxk=";
        };
        propagatedBuildInputs = with final; [
          lapis
          lua-resty-redis
        ];
        meta = {
          homepage = "https://github.com/leafo/lapis-redis";
          description = "Redis integration for Lapis";
          license = lib.licenses.mit;
        };
      };

      htmlparser = final.buildLuarocksPackage {
        pname = "htmlparser";
        version = "0.3.9-1";
        knownRockspec = (fetchurl {
          url = "mirror://luarocks/htmlparser-0.3.9-1.rockspec";
          hash = "sha256-3zi708C1iNmjDwMA8scyl81IRJOjPqCWa0y/PWi2EXc=";
        }).outPath;
        src = fetchgit {
          url = "https://github.com/msva/lua-htmlparser";
          rev = "5a595320559b5e28a591b3bcb9e7e8f799b28227";
          hash = "sha256-Ee0LIV27exXQN6+bERqnzpBAkqfZVTlL2soJVCWmlEQ=";
        };
        meta = {
          homepage = "https://msva.github.io/lua-htmlparser/";
          description = "Parse HTML text into a tree of elements with selectors";
          license = lib.licenses.lgpl2Plus;
        };
      };
    };

  luajit = luajit_openresty.override {
    packageOverrides = luaOverrides;
  };

  luaEnv = luajit.withPackages (
    ps:
    with ps;
    [
      lapis
      lapis-redis
      lua-resty-http
      lua-resty-openssl
      lua-resty-redis
      htmlparser
      lua-cjson
      lsqlite3
      luautf8
      lpeg
    ]
  );

  luaVersion = luajit.luaversion;
  luaPath = lib.concatMapStringsSep ";" (p: "${luaEnv}/${p}") [
    "share/lua/${luaVersion}/?.lua"
    "share/lua/${luaVersion}/?/init.lua"
    "lib/lua/${luaVersion}/?.lua"
    "lib/lua/${luaVersion}/?/init.lua"
  ];
  luaCPath = "${luaEnv}/lib/lua/${luaVersion}/?.so";

  lapisWrapper = subcommand: ''
    makeWrapper "${luaEnv}/bin/lapis" "$out/bin/${subcommand.wrapper}" \
      --prefix PATH : "${lib.makeBinPath [ openresty ]}" \
      --set LAPIS_OPENRESTY "${openresty}/bin/openresty" \
      --add-flags "${subcommand.command}"
  '';
in
stdenv.mkDerivation (finalAttrs: {
  pname = "kittygram";
  version = "0-unstable-2026-08-28";

  src = fetchgit {
    url = "https://codeberg.org/irelephant/kittygram";
    rev = "686fe8934822af0443a00a0e38faa6f3cd383b68";
    fetchLFS = true;
    hash = "sha256-ThMyDkkp37AluRZYSR4bplZcpfxZCGNtGq5sk5+QEIE=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    appdir="$out/share/kittygram"
    mkdir -p "$appdir"
    cp -r . "$appdir"
    chmod -R u+w "$appdir"
    rm -rf "$appdir/.git" "$appdir/.forgejo" "$appdir/docs"
    rm -f "$appdir/.gitattributes" "$appdir/.gitignore"

    # These are generated from the examples; config.lua is overridden at
    # runtime by the "docker" environment which reads environment variables.
    cp "$appdir/config.example.lua" "$appdir/config.lua"
    cp "$appdir/nginx.example.conf" "$appdir/nginx.conf"

    # Make the Lua search paths explicit instead of relying on the
    # LUA_PATH/LUA_CPATH of the invoking shell.
    substituteInPlace "$appdir/nginx.conf" \
      --replace-fail \
        'lua_package_path "./?/?.lua;./?/init.lua;;";' \
        "lua_package_path \"${luaPath};./?/?.lua;./?/init.lua;;\";"$'\n'"  lua_package_cpath \"${luaCPath};;\";"

    substituteInPlace "$appdir/config.lua" \
      --replace-fail \
        'server = "nginx",' \
        'server = "nginx",
    address = "127.0.0.1",' \
      --replace-fail \
        'trusted_certificate = "/etc/ssl/certs/ca-certificates.crt"' \
        'trusted_certificate = "${cacert}/etc/ssl/certs/ca-bundle.crt"'

    # Allow the listen address to be controlled through the `address` config
    # value (overridable at runtime with LAPIS_ADDRESS).
    substituteInPlace "$appdir/nginx.conf" \
      --replace-fail \
        'listen ''${{PORT}};' \
        'listen ''${{ADDRESS}}:''${{PORT}};' \
      --replace-fail \
        'include mime.types;' \
        'include mime.types;
  access_log logs/access.log;'

    mkdir -p "$out/bin"
    ${lapisWrapper {
      wrapper = "kittygram";
      command = "serve";
    }}
    ${lapisWrapper {
      wrapper = "kittygram-migrate";
      command = "migrate";
    }}

    runHook postInstall
  '';

  passthru = {
    inherit luaEnv luajit;
  };

  meta = {
    description = "Anonymous, privacy-friendly, lightweight Instagram frontend";
    homepage = "https://codeberg.org/irelephant/kittygram";
    license = lib.licenses.agpl3Only;
    mainProgram = "kittygram";
    platforms = lib.platforms.linux;
  };
})