final: prev: {
  keepassxc = prev.keepassxc.override {
    withKeePassBrowser = true;
    # Disable networking and X11 code for peace of mind
    withKeePassNetworking = false;
    withKeePassX11 = false;
    # Skip running tests, we will trust upstream
    # doCheck = false;
  };
}
