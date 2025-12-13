{ lib, buildGoModule, fetchFromSourcehut, pam }:

buildGoModule {
  pname = "tokidoki";
  version = "0-unstable-2024-11-25";

  src = fetchFromSourcehut {
    owner = "~sircmpwn";
    repo = "tokidoki";
    rev = "8085f6878f950f4b18740ffea98b72c3800296f6";
    sha256 = "sha256-3A4kyB2o+PdRcJYtU5k3miE45sEpp8XXwfYfmr+CA+c=";
  };

  vendorHash = "sha256-/Oj2wKqvaogS8cwXU+gY8eRwl6GHZIM6eLyy7fA0ZEg=";

  subPackages = [ "cmd/tokidoki" ];

  buildInputs = [ pam ];

  tags = [ "pam" "nullauth" ];

  ldflags = [ "-s" "-w" ];

  # Ensure PAM is available during build
  env.CGO_ENABLED = "1";

  meta = with lib; {
    description = "A CalDAV and CardDAV server";
    longDescription = ''
      Tokidoki is a CalDAV and CardDAV server that provides calendar and contact
      synchronization services. It supports multiple authentication backends
      including IMAP and PAM, and multiple storage backends including filesystem
      and PostgreSQL.
    '';
    homepage = "https://git.sr.ht/~sircmpwn/tokidoki";
    license = licenses.mit;
    mainProgram = "tokidoki";
  };
}
