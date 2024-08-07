{ ... }:

{
  services.udev.enable = true;
  services.udev.extraRules = ''
    # DualShock 3 over USB
    KERNEL=="hidraw", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0268", MODE="0666"

    # DualShock 3 over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*054C:0268*", MODE="0666"

    # DualShock 4 over USB
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"

    # DualShock 4 Wireless Adapter over USB
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ba0", MODE="0666"

    # DualShock 4 Slim over USB
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"

    # DualShock 4 over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*054C:05C4*", MODE="0666"

    # DualShock 4 Slim over Bluetooth
    KERNEL=="hidraw*", KERNELS=="*054C:09CC*", MODE="0666"

    # PS5 DualSense controller over USB hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0666", TAG+="uaccess"

    # PS5 DualSense controller over bluetooth hidraw
    KERNEL=="hidraw*", KERNELS=="*054C:0CE6*", MODE="0666", TAG+="uaccess"
  '';
}
