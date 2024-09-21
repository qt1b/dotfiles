# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./nixos-apple-silicon/apple-silicon-support
      ./nix-security-box
    ];
  hardware.asahi.peripheralFirmwareDirectory = ./firmware;

  nixpkgs.config.allowUnfree = true; # enable it if needed
  nix = {
  settings = {
    experimental-features = [ "nix-command" "flakes" ] ;
    auto-optimise-store = true;
  };
  optimise.automatic = true;
  };

  # Use the systemd-boot EFI boot loader.
  boot = {
       loader = { 
              systemd-boot.enable = true;
              # grub.enable = true;
              # grub.efiSupport = true;
              efi.canTouchEfiVariables = false;
              # efi.efiSysMountPoint = "/boot/efi";
       };
       extraModprobeConfig = ''
    options hid_apple iso_layout=0
  '';
  };

  networking = { 
    hostName = "nixos"; # Define your hostname.
/*   wireless = {
	enable = true;  # Enables wireless support via wpa_supplicant.
	iwd = {
	   enable = true;
	   settings.General.EnableNetworkConfiguration = true;
	};
  }; */
      networkmanager.enable = true;  # Easiest to use and most distros use this by default.
};
  hardware.bluetooth.enable = true;


  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
    i18n = {
      # does never really work, apparently
      defaultLocale = "ko_KR.UTF-8/UTF-8";
      extraLocaleSettings = { LC_ALL="ko_KR.UTF-8"; }; # WARN: NOT IN THE SAME FORMAT AS THE OTHERS !
      supportedLocales = [ "all" ];
      inputMethod = {
	# UIM - seems complete, but outdated and without any guide.
	# KIME - pretty good, but relies on the keyboard being qwerty and can only do korean
	# HIME - pretty outdated, but seems complete
	# FCITX5 - complete, lots of modules
	 type = "fcitx5"; 
         enable = true;
         fcitx5 =  {
	waylandFrontend = true; # EXTREMELY IMPORTANT
	settings = {
	# inputMethod = { };
	# globalOptions = { pinyin.globalSection.EmojiEnabled = "True"; };
	# addons = { };
	};
	# quickPhraseFiles = { };
	# i18n.inputMethod.fcitx5.ignoreUserConfig = false # can be enabled to do all the config there
	# just for the joke
  	quickPhrase = {
  smile = "（・∀・）";
  angry = "(￣ー￣)";
};
	addons = with pkgs; [ 
# fcitx5-gtk #alternatively, 
	kdePackages.fcitx5-qt # is QT6, libsforqt5. is qt5
        kdePackages.fcitx5-configtool
       fcitx5-chinese-addons  # table input method support
       fcitx5-nord            # a color theme
       fcitx5-mozc
       fcitx5-hangul
       fcitx5-anthy
       fcitx5-skk
       fcitx5-material-color  
];
};
         ibus.engines = with pkgs.ibus-engines; [
	anthy mozc kkc
	hangul
	uniemoji
	libpinyin
];
        uim.toolbar = "gtk3-systray";
  };
  };

   #  environment.variables.GLFW_IM_MODULE = "ibus"; # useful for kitty ?
  console = {
     # useXkbConfig = true;
     keyMap = "dvorak";
     # incorrect name for now # font = "FiraCode Nerd Font Mono Light";
  };
  fonts = { 
    packages = with pkgs; [ 
	fira-code-nerdfont 
	mplus-outline-fonts.githubRelease 
	noto-fonts-cjk
	source-code-pro
	ipafont
	kochi-substitute
    ];
    fontconfig.allowBitmaps = false; 
};
services = {
   xserver = {
      enable = false;
      xkb = {
         layout = "us,us";
         variant = "dvorak-alt-int,";
         options = "grp:alt_space_toggle,caps:escape";
      };
   };
  printing.enable = true; # enable CUPS, may be useful
  libinput.enable = true; # enable touchpad support
  pipewire = {
     enable = true;
     pulse.enable = true; # i plan on disabling it soon, but is still useful for now
     };
  power-profiles-daemon.enable = true;
};

  # Enable CUPS to print documents.
programs = {	
	nix-ld.enable = true;
	hyprland.enable = true; hyprlock.enable = true;
	waybar.enable = true; thunar.enable = true; 
	neovim.enable = true;
	vim = {
	  enable = true;
	  defaultEditor = true; 
	};
zsh = {
	enable = true; 
	promptInit = "source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
	shellInit = "tmux"
};
fish = {
	enable = true; 
	shellInit = "tmux";
};
	tmux = {
		enable = true;
		clock24 = true;
		plugins = with pkgs.tmuxPlugins; [ nord tilish battery better-mouse-mode tmux-fzf mode-indicator # dracula tokyo-night-tmux tmux-thumbs gruvbox
			];
		extraConfig = ''
			set -g mouse on
		'';
	};
	yazi.enable = true; 
	# not configured correcly, but is there
	uwsm = {
	enable = true;
	waylandCompositors = {
	  hyprland = { 
		 hyprland = {
                 prettyName = "Hyprland";
                 comment = "Hyprland compositor managed by UWSM";
                 binPath = "/run/current-system/sw/bin/Hyprland";
               };
	  };
	};
	};
  };


  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.kiu = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     packages = with pkgs; [
       firefox
       tree
     ];
     shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
   environment = { 
systemPackages = with pkgs; [
      wget kate nushell zsh-powerlevel10k
     git gh p7zip
     tmux bluez
     kitty foot alacritty
     gcc gnumake rustc zig python3 go lua
	# for asahi
	asahi-bless asahi-nvram asahi-btsync asahi-wifisync
     # winmgr related
     mpv cliphist swww swaybg # mpd
     kdePackages.dolphin 
     brightnessctl
     nwg-look qt5ct qt6ct
     keepassxc
      rofi-wayland
     libnotify swaynotificationcenter wlogout # or dunst # no need for pamixer with wpctl (by default with pipewire, who install wireplumber)
     wev # should not be that useful # WEV is how to get keycodes
     # can be useful for emulation
     krunvm krun # krun # is in unstable
     box64 # no wine in aarch64 for now
     hime kime # kime for korean

# IMEs, should better be in i18n.engine but hey
# hime kime
    
   ];
    sessionVariables.MOZ_GMP_PATH = [ "${pkgs.widevine-cdm-lacros}/gmp-widevinecdm/system-installed" ]; 
    variables = {
	VISUAL = "/run/current-system/sw/"
    }
};

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  security = {
    doas.enable = true; # does not work with nix
    polkit.enable = true;
    sudo.enable = true; # is required for nix (and some other)
  };

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system = { 
     # copySystemConfiguration = true; # isn't supported with flakes
     stateVersion = "24.11"; # Did you read the comment?
  };
}

