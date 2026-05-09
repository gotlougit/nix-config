# Overlay to fix stremio-linux-shell runtime PATH handling
final: prev: {
  stremio-linux-shell = prev.stremio-linux-shell.overrideAttrs (
    old:
    let
      mpvBinPath = "${prev.lib.makeBinPath [ prev.mpv ]}";
    in
    {
      preFixup = (old.preFixup or "") + ''
        gappsWrapperArgs+=(
          --prefix PATH : "${mpvBinPath}"
        )
      '';
    }
  );
}
