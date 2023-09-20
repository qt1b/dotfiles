# module that aims to setup gnome with a proper config for the user.

{ config, pkgs, ... }:

{

  # Enable the GNOME Desktop Environment.
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # GNOME fixes
  services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];

  # use kde and default qt themes because they look way better
  qt5.enable = true; # Enable qt theming
  qt5.platformTheme = "kde";
  # qt5.style= "cleanlook"; # enable if no kde config in the user directory

  # exculde packages from the GNOME install --- from nixos.wiki
 environment.gnome.excludePackages = (with pkgs; [
  gnome-photos
  gnome-tour
]) ++ (with pkgs.gnome; [
  cheese # webcam tool
  gnome-music
  gedit # text editor
  epiphany # web browser
  geary # email reader
  evince # document viewer
  gnome-characters
  totem # video player
  tali # poker game
  iagno # go game
  hitori # sudoku game
  atomix # puzzle game
]);

  # exclude xterm
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  # IME : IBUS ---
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ anthy kkc mozc ];
  };
   /*#should not be needed for gnome
  environment.sessionVariables = {
    GTK_IM_MODULE = "ibus";
    QT_IM_MODULE  = "ibus";
    XMODIFIERS= "@im=ibus";
  }; */


  # SYSTEM PACKAGE INSTALL
  environment.systemPackages = with pkgs; [
    # GNOME specific config
    gnome.adwaita-icon-theme
    gnomeExtensions.appindicator
  ];

  # USER PACKAGES INSTALL
  users.users.kiu.packages = with pkgs; [
      gnome-text-editor
      kate
    ];
  };

}
