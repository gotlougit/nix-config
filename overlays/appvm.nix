final: prev: {
  appvm = prev.appvm.overrideAttrs (oldAttrs: {
    src = prev.fetchFromGitHub {
      owner = "gotlougit";
      repo = "appvm";
      rev = "6381394436aba2420090fac61c890710c917f788";
      sha256 = "sha256-Y0dons+weAX563E/OsXsIqiStiuumRdOehdA6UIBJ80=";
    };
    vendorHash = "sha256-8eU+Mf5dxL/bAMMShXvj8I1Kdd4ysBTWvgYIXwLStPI=";
  });
}

