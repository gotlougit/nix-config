# Overlay to add openssh-filc package (Fil-C memory-safe build of OpenSSH)
#
# Builds OpenSSH 10.3p1 using the Fil-C compiler via the mbrock/filnix flake,
# which wraps the upstream pizlonator/fil-c `projects/openssh-10.3p1/` source
# (already patched with GSSAPI key exchange + Fil-C sandbox compatibility fixes)
# and cross-compiles it with `x86_64-unknown-linux-gnufilc0`.
#
# The output is a cross-compiled Fil-C binary that needs the Fil-C runtime to
# run, but the goal here is to be able to build the package on the user's
# system, not to actually run it.
{ inputs }: final: prev: {
  openssh-filc = import ./openssh-filc.nix {
    inherit inputs;
    fetchFromGitHub = prev.fetchFromGitHub;
  };
}
