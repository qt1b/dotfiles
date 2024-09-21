{ config, pkgs, ... }:

{
    boot.initrd.kernelModules = [ "amdgpu" ];

    services.xserver.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];

/*  enable if you have an "old" amd gpu
 # for Southern Islands (SI ie. GCN 1) cards
boot.kernelParams = [ "radeon.si_support=0" "amdgpu.si_support=1" ];
# for Sea Islands (CIK ie. GCN 2) cards
boot.kernelParams = [ "radeon.cik_support=0" "amdgpu.cik_support=1" ];
*/

  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

hardware.opengl.extraPackages = with pkgs; [
  rocm-opencl-icd
  rocm-opencl-runtime
  amdvlk
];


 hardware.opengl.driSupport = true;
# For 32 bit applications
hardware.opengl.driSupport32Bit = true;

# For 32 bit applications
# Only available on unstable
hardware.opengl.extraPackages32 = with pkgs; [
  driversi686Linux.amdvlk
];

}
