{ pkgs, ... }:

{
  home.packages = with pkgs; [

    # Utils
    chiaki-ng # PS4/5 Remote Play client
    mangohud # Overlay for FPS, frametime, CPU, GPU usage etc

    # Games
    # luanti # Open source Minecraft-like game

    # Launchers
    # heroic # GOG + Epic + Amazon Game launcher + Proton wrapper to boot

    # Emulators
    # cemu # Wii U emulator
    # dolphin-emu # GameCube and Wii emulator
    # duckstation # PS1 emulator
    # pcsx2 # PS2 emulator
    # rpcs3 # PS3 emulator
    # xemu # Original Xbox emulator
    # ryubing # Switch emulator
  ];
}
