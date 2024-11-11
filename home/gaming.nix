{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Gaming stuff
    cemu # Wii U emulator
    chiaki-ng # PS4 Remote Play client
    dolphin-emu # GameCube and Wii emulator
    duckstation # PS1 emulator
    pcsx2 # PS2 emulator
    rpcs3 # PS3 emulator
    xemu # Original Xbox emulator
    minetest # Open source Minecraft-like game
  ];
}
