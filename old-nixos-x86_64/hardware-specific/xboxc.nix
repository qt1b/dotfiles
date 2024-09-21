{ config, pkgs, ... }:

{
  hardware.bluetooth = {
    enable = true;
    settings = { # necessary for the xbox series X|S controllers as of kernel 5.17 - Jan 24 06:22:49 UTC 2023
      General = {
        ControllerMode="dual";
        Privacy = "device";
        JustWorksRepairing = "always";
        Class = "0x000100";
        FastConnectable = "true";
      };
    };
  };
  environment.systemPackages = with pkgs; [
  linuxKernel.packages.linux_zen.xpadneo
  ];
}
