self: super:
let
  mullvad-browser = super.mullvad-browser;
in
super // {
  mullvad-browser = super.mullvad-browser-sandbox;
}
