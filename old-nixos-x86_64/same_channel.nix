{ config, pkgs, ... }:

# this module is made to be used as a replacement of unstable_apps.nix when the unstable channel is the main channel of the system

{
    users.users.kiu.packages = with pkgs;
    [
    ryujinx yuzu ppsspp mgba pcsx2 duckstation dolphin-emu-beta melonDS ares # emulation
    tauon firefox librewolf brave
    steam osu-lazer-bin # unfree apps
    ];

}
