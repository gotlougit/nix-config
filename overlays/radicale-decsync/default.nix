# Overlay to add radicale-decsync packages to nixpkgs
final: prev:

let
  # Call package with the current package set
  callPackage = prev.lib.callPackageWith (prev // final);
in

{
  # Add the C library
  libdecsync = callPackage ./packages/libdecsync.nix { };

  # Extend python3Packages with our custom packages
  python3 = prev.python3.override {
    packageOverrides = python-final: python-prev: {
      libdecsync = callPackage ./packages/python3-libdecsync.nix {
        inherit (python-prev) buildPythonPackage fetchPypi;
      };

      radicale-storage-decsync = callPackage ./packages/radicale-storage-decsync.nix {
        inherit (python-prev) buildPythonPackage vobject;
        libdecsync = python-final.libdecsync;
      };
    };
  };

  python3Packages = final.python3.pkgs;

  # Create a custom radicale package with DecSync support
  radicale-with-decsync = prev.radicale.overridePythonAttrs (old: {
    nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
      prev.makeWrapper
    ];

    propagatedBuildInputs = (old.propagatedBuildInputs or []) ++ [
      final.python3Packages.libdecsync
      final.python3Packages.radicale-storage-decsync
    ];

    postInstall = (old.postInstall or "") + ''
      # Wrap radicale binary to include libdecsync compatibility library path
      wrapProgram $out/bin/radicale \
        --prefix LD_LIBRARY_PATH : "${final.python3Packages.libdecsync}/lib/compat"
    '';
  });
}
