{
  description = "NF NixOS System Configuration";
  
  #let
  #  release = "22.11";
  #in 
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11"; #${release}";
    home-manager.url = "github:nix-community/home-manager/release-22.11"; #${release}";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: 
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs {
      inherit system;
      config = { allowUnfree = true; };
    };

  in {
    # System configuration
    nixosConfigurations = {
      artemis = nixpkgs.lib.nixosSystem {
        inherit system;

	modules = [
	  (./modules/configuration.nix)
	  ({pkgs, ... }: {
            # Pin system nixpkgs to system-wide flake registry
            nix.registry.nixpkgs.flake = nixpkgs;
	    # Let 'nixos-version --json' know about the Git revision
            # of this flake.
	    # and require clean git tree
	    system.configurationRevision =
              if self ? rev
              then self.rev
              else throw "Refusing to build from a dirty Git tree!";
	  })
	];
      };
    };
  };
}
