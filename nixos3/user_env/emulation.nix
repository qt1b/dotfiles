{ config, pkgs, ... }:

{
    environment.systemPackages = with pkgs; [
    SDL2 cubeb openal # for ryujinx
    steam-run nsz appimage-run steam # useful for running binaries on nix-os
    yuzu ryujinx citra melonDS pcsx2 rpcs3
    ];
}
