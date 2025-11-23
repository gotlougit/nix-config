self: super: {
  vamp-cli = super.amp-cli.overrideAttrs (oldAttrs: {
    pname = "vamp-cli";
    
    postInstall = ''
      # Patch the @sourcegraph/amp dependency in the nested node_modules
      substituteInPlace $out/lib/node_modules/amp-cli/node_modules/@sourcegraph/amp/dist/main.js \
        --replace-warn "https://ampcode.com/" "http://127.0.0.1:25799/"
    '' + (oldAttrs.postInstall or "");
   
  });
}
