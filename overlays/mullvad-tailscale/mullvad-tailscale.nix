{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  makeWrapper,
  bash,
  mullvad,
  nftables,
  tailscale,
  gawk,
  coreutils,
  gnugrep,
  gnused,
  getopt,
}:

stdenvNoCC.mkDerivation rec {
  pname = "mullvad-tailscale";
  version = "0-unstable-2026-05-07";

  src = fetchFromGitHub {
    owner = "r3nor";
    repo = "mullvad-tailscale";
    rev = "9b8abcd31dda09f435531272268d571243aae9b2";
    hash = "sha256-xfXAhL6dcfEpvirX5jOGsCu232I4N8lGlEu3gHheZv8=";
  };

  nativeBuildInputs = [ makeWrapper ];

  # No build step needed; script-only package
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 mnf "$out/bin/mnf"
    install -Dm644 mullvad.rules "$out/share/mullvad-tailscale/mullvad.rules"

    # Patch the RULES_DIR to point to the installed rules file directory
    substituteInPlace "$out/bin/mnf" \
      --replace-fail 'RULES_DIR="$(dirname "$(realpath "$0")")"' \
      'RULES_DIR="'"$out/share/mullvad-tailscale"'"'

    # Wrap with runtime dependencies
    wrapProgram "$out/bin/mnf" \
      --prefix PATH : "${
        lib.makeBinPath [
          bash
          mullvad
          nftables
          tailscale
          gawk
          coreutils
          gnugrep
          gnused
          getopt
        ]
      }"

    runHook postInstall
  '';

  meta = with lib; {
    description = "Bash script to run Mullvad VPN alongside Tailscale or Zerotier using nftables";
    longDescription = ''
      A simple bash script that configures nftables rules to allow Mullvad VPN
      to work together with Tailscale or Zerotier on Linux. It manages the VPN
      connection, nftables configuration, and supports country filtering, RAM-only
      servers, and custom DNS.
    '';
    homepage = "https://github.com/r3nor/mullvad-tailscale";
    license = licenses.mit;
    mainProgram = "mnf";
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
