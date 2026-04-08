{
  description = "David's Leo's Morc's NixOS configs";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    frostix = {
      url = "github:shomykohai/frostix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tvh.url = "github:oneingan/nixpkgs/tvheadend-revive";
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ];
      treefmtEval = forAllSystems (
        system:
        inputs.treefmt-nix.lib.evalModule nixpkgs.legacyPackages.${system} (
          { pkgs, ... }:
          {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
              keep-sorted.enable = true;
            };
            settings = {
              verbose = 1;
              on-matched = "debug";
            };
          }
        )
      );

    in
    {
      nixosConfigurations.LatitudeE7270 = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          vars = import ./vars.nix;
          frostix = inputs.frostix.packages.x86_64-linux;
        };
        system = "x86_64-linux";
        modules = [
          ./machines/latitudee7270
        ];
      };

      nixosConfigurations.mini = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          vars = import ./vars.nix;
          frostix = inputs.frostix.packages.x86_64-linux;
        };
        system = "x86_64-linux";
        modules = [
          ./machines/mini
        ];
      };

      packages =
        nixpkgs.lib.recursiveUpdate
          (forAllSystems (system: {
          }))
          {
            x86_64-linux = {
              #ida-pro = nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/ida-pro.nix { };
            };
          };
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);
      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check inputs.self;
      });

    };
}
