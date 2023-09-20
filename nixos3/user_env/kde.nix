{ config, pkgs, ... }:

# this config is for a comfy plasma5/kde desktop

/* CHAPTERS
ENABLE KDE
EXCLUDE PACKAGES
EXPERIMENTAL SETTINGS
IME (日本語)
APP INSTALL - SYSTEM
APP INSTALL - USER
APP CONIFG
*/

{

  # Enable the X11 windowing system : needed for sddm ( kde login ) even if wayland is used
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # EXCLUDE PACKAGES

  environment.plasma5.excludePackages = with pkgs.libsForQt5; [ elisa kwrited kwallet kwalletmanager ];
  #- services.xserver.desktopManager.plasma5.excludePackages = with pkgs.libsForQt5; [ elisa kwrited kwalletmanager ]; # is the old name ; does not seem to exclude kwrited (kwite) and kwalletmanager successfully

  services.xserver.excludePackages = [ pkgs.xterm ];   # exclude xterm
  services.xserver.desktopManager.xterm.enable = false; # ''

  # EXPERIMENTAL SETTINGS
  programs.dconf.enable = true; # should be a fix for gtk apps


/*
  # jp IME
  i18n.inputMethod = {
    enabled = "uim"; # hime fcitx5 ibus
    uim.toolbar = "qt4";
    # fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-configtool libsForQt5.fcitx5-qt fcitx5-gtk fcitx5-lua ]; # lua may be useful ? idk
    # ibus.engines = with pkgs.ibus-engines; [ mozc hangul ] ;
  };

  environment.sessionVariables = {
    GTK_IM_MODULE = "uim";
    QT_IM_MODULE  = "uim";
    XMODIFIERS= "@im=uim";
    };
*/


  # jp IME : fcitx5
  i18n.inputMethod = {
    enabled = "fcitx5";
    fcitx5.addons = with pkgs; [ fcitx5-mozc fcitx5-configtool libsForQt5.fcitx5-qt fcitx5-gtk fcitx5-lua ]; # lua may be useful ? idk
  };
  environment.sessionVariables = { # variables for fcitx to work
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE  = "fcitx";
    XMODIFIERS= "@im=fcitx";
  };



  # APP INSTALL - SYSTEM


  # APP INSTALL - USER
  users.users.kiu.packages = (with pkgs ;[
    partition-manager kate ]) ++ (with pkgs.libsForQt5 ; [
    ark okular kdeconnect-kde
    kpmcore # required for partition-manager
  ]);


  # APP CONFIG
  programs.partition-manager.enable = true; # enable the KDE partition manager
  programs.kdeconnect.enable = true;

}
