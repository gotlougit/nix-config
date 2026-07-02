# ref: https://github.com/nix-community/home-manager/issues/8981
# or https://github.com/ghostty-org/ghostty/discussions/10617
final: prev: {
  ghostty = prev.ghostty.overrideAttrs (old: {
    postFixup = (old.postFixup or "") + ''
      desktop="$out/share/applications/com.mitchellh.ghostty.desktop"

      if [ -f "$desktop" ]; then
        substituteInPlace "$desktop" \
          --replace-fail 'DBusActivatable=true' 'DBusActivatable=false'
      fi
    '';
  });
}
