
{ config, pkgs, ... }:

{
  imports = [
    ./amd_gpu.nix
    ./xboxc.nix
  ];
}
