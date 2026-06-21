{ ... }:
{
  # Enable sound.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
  };

  # Some WirePlumber stuff to handle bluetooth correctly
  services.pipewire.wireplumber.enable = true;
  environment.etc."wireplumber/wireplumber.conf.d/50-bluetooth-config.conf".text = ''
    monitor.bluez.properties = {
      bluez5.enable-sbc-xq = true
      bluez5.enable-msbc = true
      bluez5.enable-hw-volume = true
      bluez5.headset-roles = [ hsp_hs hsp_ag hfp_hf hfp_ag ]
    }
  '';
}
