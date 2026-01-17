{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromSourcehut,
  jq,
  pkg-config,
  clang_20,
  libsecret,
  ripgrep,
  nodejs_22,
  nix-update-script,
}:

buildNpmPackage (finalAttrs: {
  pname = "libra-cli";
  version = "0.1.0";

  src = fetchFromSourcehut {
    owner = "~gotlou";
    repo = "antigravity-cli";
    rev = "11c896de525dad5fc1fb4c00bef41b3f02e5768e";
    hash = "sha256-Ppbcyl39y58pT2W4vw6d1THnUti/wfm6whHggLu8OBk=";
  };

  nodejs = nodejs_22;

  npmDepsHash = "sha256-6PnZlhHk70aPmhIdRIt75rDIQrvZ7aSu6lGJXM6lRjU=";

  nativeBuildInputs = [
    jq
    pkg-config
  ]
  ++ lib.optionals stdenv.isDarwin [ clang_20 ]; # clang_21 breaks @vscode/vsce's optionalDependencies keytar

  buildInputs = [
    ripgrep
    libsecret
  ];

  preConfigure = ''
    mkdir -p packages/generated
    echo "export const GIT_COMMIT_INFO = { commitHash: '${finalAttrs.src.rev}' };" > packages/generated/git-commit.ts
  '';

  postPatch = ''
    # Remove node-pty dependency from package.json
    ${jq}/bin/jq 'del(.optionalDependencies."node-pty")' package.json > package.json.tmp && mv package.json.tmp package.json

    # Remove node-pty dependency from packages/core/package.json
    ${jq}/bin/jq 'del(.optionalDependencies."node-pty")' packages/core/package.json > packages/core/package.json.tmp && mv packages/core/package.json.tmp packages/core/package.json

    # Fix ripgrep path for SearchText; ensureRgPath() on its own may return the path to a dynamically-linked ripgrep binary without required libraries
    substituteInPlace packages/core/src/tools/ripGrep.ts \
      --replace-fail "await ensureRgPath();" "'${lib.getExe ripgrep}';"

    # Ideal method to disable auto-update
    sed -i '/disableAutoUpdate: {/,/}/ s/default: false/default: true/' packages/cli/src/config/settingsSchema.ts

    # Disable auto-update for real because the default value in settingsSchema isn't cleanly applied
    # https://github.com/google-gemini/gemini-cli/issues/13569
    substituteInPlace packages/cli/src/utils/handleAutoUpdate.ts \
      --replace-fail "settings.merged.general?.disableAutoUpdate ?? false" "settings.merged.general?.disableAutoUpdate ?? true" \
      --replace-fail "settings.merged.general?.disableAutoUpdate" "(settings.merged.general?.disableAutoUpdate ?? true)"
    substituteInPlace packages/cli/src/ui/utils/updateCheck.ts \
      --replace-fail "settings.merged.general?.disableUpdateNag" "(settings.merged.general?.disableUpdateNag ?? true)"
  '';

  # Prevent npmDeps and python from getting into the closure
  # disallowedReferences = [
  #   finalAttrs.npmDeps
  #   nodejs_22.python
  # ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/{bin,share/gemini-cli}

    npm prune --omit=dev
    rm node_modules/shell-quote/print.py # remove python demo to prevent python from getting into the closure
    cp -r node_modules $out/share/gemini-cli/

    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-core
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-a2a-server
    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-test-utils
    rm -f $out/share/gemini-cli/node_modules/gemini-cli-vscode-ide-companion
    cp -r packages/cli $out/share/gemini-cli/node_modules/@google/gemini-cli
    cp -r packages/core $out/share/gemini-cli/node_modules/@google/gemini-cli-core
    cp -r packages/a2a-server $out/share/gemini-cli/node_modules/@google/gemini-cli-a2a-server

    rm -f $out/share/gemini-cli/node_modules/@google/gemini-cli-core/dist/docs/CONTRIBUTING.md

    ln -s $out/share/gemini-cli/node_modules/@google/gemini-cli/dist/index.js $out/bin/libra
    chmod +x "$out/bin/libra"

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "AI agent that brings the power of Gemini directly into your terminal";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    maintainers = with lib.maintainers; [
      xiaoxiangmoe
      FlameFlag
      taranarmo
    ];
    platforms = lib.platforms.all;
    mainProgram = "libra";
  };
})
