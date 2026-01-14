{
  lib,
  rustPlatform,
  fetchFromSourcehut,
  pkg-config,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "autodevenv";
  version = "0.1.0-unstable-2025-12-29";

  src = fetchFromSourcehut {
    owner = "~gotlou";
    repo = "autodevenv";
    rev = "e25f0fc1c77c67e90b7a435bd97025f5f847812a";
    hash = "sha256-3XgW+DPPM2eDwddBZRsPs1v9Fpa1iFmkGHHkskwm3HI=";
  };

  cargoHash = "sha256-IiJfTNS9AsfgszTHJSzXWHbNtYfWMcbzjDHE3obSvoQ=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  meta = {
    description = "A tool to automatically generate development environments";
    homepage = "https://git.sr.ht/~gotlou/autodevenv";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.linux;
    mainProgram = "autodevenv";
  };
})
