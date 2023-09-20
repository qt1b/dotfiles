 { config, pkgs, ... }:

{
    hardware.opengl.driSupport32Bit = true ; # may help ?
    environment.systemPackages = with pkgs ;
    [
    wineWowPackages.stagingFull # wineWowPackages.waylandFull
    winetricks wineasio dxvk
    xdotool wtype
    ];
}

