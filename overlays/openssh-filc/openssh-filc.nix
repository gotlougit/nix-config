# Fil-C build of OpenSSH 10.3p1.
#
# We start from the filnix port of OpenSSH 9.8p1
# (see /tmp/filnix/ports.nix — the `for pkgs.openssh [...]` block), which gives
# us a cross-compiled Fil-C build with:
#   * depizloing-nm tool wired into nativeBuildInputs
#   * `withFIDO = false` (the filnix port disables FIDO)
#   * `doCheck = false`
#   * installCheckPhase that grep's `OpenSSH_${version},` from `ssh -V` / `sshd -V`
#   * filcc (Fil-C clang) as the cross-stdenv compiler
#   * the cross sysroot containing the Fil-C runtime
#
# We then override:
#   * `pname`, `version` — bump to 10.3p1
#   * `src` — point at the upstream pizlonator/fil-c `deluge` branch, which has
#     a pre-patched projects/openssh-10.3p1/ source tree (already includes the
#     openssh-gsskex patches and the small Fil-C sandbox compatibility hunks
#     that the filnix 9.8p1 patch adds manually)
#   * `patches = []` — drop the filnix 9.8p1 patch since the upstream source is
#     already patched
#   * `sourceRoot` — tell stdenv where the configure script lives
#
# The filnix installCheckPhase reads `${version}`, so once we set it to "10.3p1"
# it will look for `^OpenSSH_10.3p1,`, which matches the 10.3p1 binary's
# `SSH_RELEASE` ("OpenSSH_10.3" + "p1" → "OpenSSH_10.3p1").
{ inputs, fetchFromGitHub }:
let
  system = "x86_64-linux";
  pkgsFilc = inputs.filnix.legacyPackages.${system}.pkgsFilc;

  # Pinned to a specific rev of pizlonator/fil-c on the `deluge` branch. The
  # `deluge` branch moves; the rev below matches what is currently checked out
  # in /home/gotlou/nixos/scratch/fil-c. update.sh refreshes it.
  filcRev = "878cb9edfdd2457aaf173e92fcb14a850c344b04";

  # Dummy hash so `nix flake check --no-build` evaluates without trying to
  # fetch the full fil-c tarball. The real hash is computed by update.sh
  # (which uses `nix-prefetch-github` to download the archive and hash it).
  # Note: the fil-c repo is ~1.1GB compressed because it contains the LLVM/Clang
  # fork — this hash covers the full tarball. update.sh handles the prefetch.
  # fork — this hash covers the full tarball. Computed locally with
  # `nix hash path` on the unpacked archive. update.sh refreshes both rev and
  # hash together.
  filcHash = "sha256-QiNGccMkdXHvscODUrrvR24vhh6eeHBf814NvUtywoU=";
in
pkgsFilc.openssh.overrideAttrs (old: {
  pname = "openssh";
  version = "10.3p1";

  src = fetchFromGitHub {
    owner = "pizlonator";
    repo = "fil-c";
    rev = filcRev;
    hash = filcHash;
  };

  # fetchFromGitHub's default name is "source", so the tarball extracts to
  # <storepath>/source/ and the openssh-10.3p1 tree is at
  # <storepath>/source/projects/openssh-10.3p1/.
  sourceRoot = "source/projects/openssh-10.3p1";

  # Drop the filnix 9.8p1 patch (and the nixpkgs upstream patches). The
  # upstream fil-c 10.3p1 source is already pre-patched with the equivalent
  # changes, so we don't need to re-apply anything.
  patches = [ ];
})
