{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Gaming stuff
    cemu # Wii U emulator
    # chiaki-ng # PS4/5 Remote Play client
    dolphin-emu # GameCube and Wii emulator
    # duckstation # PS1 emulator
    pcsx2 # PS2 emulator
    rpcs3 # PS3 emulator
    # xemu # Original Xbox emulator
    luanti # Open source Minecraft-like game
    heroic # GOG + Epic + Amazon Game launcher + Proton wrapper to boot
    mangohud # Overlay for FPS, frametime, CPU, GPU usage etc
    ryubing # Switch emulator
  ];
}
