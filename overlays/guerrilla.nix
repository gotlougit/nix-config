{ buildGoModule, lib, fetchFromGitHub }:

buildGoModule {
  pname = "guerrilla";
  version = "0.1";
  vendorHash = "sha256-1xr2f+h04P9at3Twr4IdVinX3+i3zev+E3lZzAIBF9c=";
  src = fetchFromGitHub {
    owner = "liamg";
    repo = "guerrilla";
    rev = "3f0c39944f4dffef7ca9b325d66f5c01d2a925d5";
    hash = "sha256-mEXT24qz1CiL3HllUaPtCwGg1g/oBrTbPcq6j82jzRk=";
  };
  meta = with lib; {
    description =
      "A command-line tool (and Go module) for https://www.guerrillamail.com/";
    homepage = "https://github.com/liamg/guerrilla";
    license = licenses.mit;
  };
}
