{ lib, writeShellApplication, emacs29-nox }:
let
  emacs = emacs29-nox.pkgs.withPackages (e: [ e.magit e.ivy e.evil e.evil-collection ]);
in
writeShellApplication {
  name = "magit";
  runtimeInputs = [ emacs ];
  text = "emacs --init-directory ${lib.escapeShellArg ./.}";
}
