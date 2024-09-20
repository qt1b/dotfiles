{
  description = "qt1b's m1 standart system configuration, mostly importing widevine ";

  inputs = {
    nixos-aarch64-widevine.url = "github:epetousis/nixos-aarch64-widevine";
  };

  outputs = { self, nixpkgs, nixos-aarch64-widevine, ... }@inputs:
{
    nixosConfigurations = {
	"nixos" = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [ ./configuration.nix
        {
          nixpkgs.overlays = [ nixos-aarch64-widevine.overlays.default ];
        }
      ]; 
    };
  };
};
}
