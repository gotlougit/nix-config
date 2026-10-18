{
  lib,
  stdenv,
  fetchzip,
  yarn-berry_4,
  autoPatchelfHook,
  makeWrapper,
  nodejs_24,
  curl,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hitman-ps5";
  version = "0.3.6";

  src = fetchzip {
    url = "https://github.com/theghostonline/Hitman-PS5/releases/download/v${finalAttrs.version}/hitman-ps5-backend-src-${finalAttrs.version}.zip";
    hash = "sha256-/Y2wUQQePx+gKBHO8Ah+n1PHhByhlCmL8FZB5K3GEys=";
  };

  nativeBuildInputs = [
    nodejs_24
    autoPatchelfHook
    makeWrapper
  ];
  buildInputs = [ stdenv.cc.cc.lib ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry_4.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-WCEr4o24u+pQBZA7iNbW590obOgrtB6F9u6RWF/kHWU=";
  };

  env = {
    YARN_ENABLE_SCRIPTS = "false";
    YARN_ENABLE_TELEMETRY = "0";
    YARN_ENABLE_NETWORK = "false";
  };

  configurePhase = ''
    runHook preConfigure
    export YARN_GLOBAL_FOLDER="$TMPDIR/yarn-global"
    yarn_cli=$(sed -n 's/^yarnPath: //p' .yarnrc.yml)
    cmp yarn.lock ${finalAttrs.offlineCache}/yarn.lock
    cp -r ${finalAttrs.offlineCache}/cache .yarn/cache
    chmod -R u+w .yarn/cache
    node "$yarn_cli" install --immutable --mode=skip-build
    patchShebangs node_modules
    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild
    autoPatchelf node_modules
    node "$yarn_cli" build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p "$out/lib/hitman-ps5" "$out/bin"
    cp -r chunk0.js resources LICENSE THIRDPARTYNOTICES.txt PS5-CHANGES.md "$out/lib/hitman-ps5/"
    mkdir -p "$out/lib/hitman-ps5/webui"
    cp -r webui/dist "$out/lib/hitman-ps5/webui/"
    cp components/ps5/ps5_store_strings.json "$out/lib/hitman-ps5/resources/"
    cp hitman-ps5/release/backend/{build-ps5-package.mjs,options.ini} "$out/lib/hitman-ps5/"
    printf '%s\n' '${finalAttrs.version}' > "$out/lib/hitman-ps5/VERSION"

    makeWrapper ${nodejs_24}/bin/node "$out/bin/hitman-ps5" \
      --add-flags "$out/lib/hitman-ps5/chunk0.js" \
      --run 'mkdir -p "''${HITMAN_PS5_STATE_DIR:-.}"' \
      --run 'cd "''${HITMAN_PS5_STATE_DIR:-.}"' \
      --run "if [ ! -e options.ini ]; then install -m 0600 '$out/lib/hitman-ps5/options.ini' options.ini; fi" \
      --set-default HOST 0.0.0.0 \
      --set-default PORT 8410

    makeWrapper ${nodejs_24}/bin/node "$out/bin/hitman-ps5-build-resources" \
      --prefix PATH : ${lib.makeBinPath [ curl ]} \
      --add-flags "$out/lib/hitman-ps5/build-ps5-package.mjs" \
      --add-flags "--out /var/lib/hitman-ps5/ps5/dynamic_resources_ps5.rpkg"
    runHook postInstall
  '';

  meta = {
    description = "HITMAN PS5 Node backend based on Peacock";
    homepage = "https://github.com/theghostonline/Hitman-PS5";
    license = lib.licenses.agpl3Plus;
    platforms = lib.platforms.linux;
    mainProgram = "hitman-ps5";
  };
})
