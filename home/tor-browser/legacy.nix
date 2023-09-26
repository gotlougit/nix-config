{ inputs, tor-browser-bundle-bin, ... }:
let
  inherit (inputs) legacy;
in
tor-browser-bundle-bin.overrideDerivation (oldAttrs: {
  buildPhase = oldAttrs.buildPhase + "\n" + ''
    cat "${legacy}/vimfx-config.js" >> "$MB_IN_STORE/mozilla.cfg"
    echo 'pref("general.config.sandbox_enabled", false);' >> "$MB_IN_STORE/defaults/pref/autoconfig.js"
    cp "${legacy}/legacy.manifest" "$MB_IN_STORE"
    cp -r "${legacy}/legacy" "$MB_IN_STORE"
  '';
})
