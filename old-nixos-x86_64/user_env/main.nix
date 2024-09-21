{ config, pkgs, ... }:

{
    imports = [
        ./kde.nix
        # ./gnome.nix
        # ./i3.nix
        # ./sway.nix
        # ./hyprland.nix
        ./emulation.nix
    ];

    services.flatpak.enable = true;
}
