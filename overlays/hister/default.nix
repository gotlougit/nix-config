{ inputs }:
final: prev: {
  hister = inputs.hister.packages.${final.stdenv.hostPlatform.system}.default.overrideAttrs (old: {
    patches = (old.patches or [ ]) ++ [
      ./allow-arbitrary-origin.patch
    ];
  });
}
