{
  description = "David's NixOS configs (LEANDRO EDITION)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    frostix = {
      url = "github:shomykohai/frostix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    funnyprint = {
      url = "github:ValdikSS/printer-driver-funnyprint";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
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
      nixosConfigurations.KankerPad = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          vars = import ./vars.nix;
          frostix = inputs.frostix.packages.x86_64-linux;
        };
        system = "x86_64-linux";
        modules = [
          ./machines/kankerpad
          inputs.funnyprint.nixosModules.funnyprint
        ];
      };

      packages =
        nixpkgs.lib.recursiveUpdate
          (forAllSystems (system: {
            mdns-scan = nixpkgs.legacyPackages.${system}.callPackage ./packages/mdns-scan.nix { };
            ttf-ms-win11 = nixpkgs.legacyPackages.${system}.callPackage ./packages/ttf-ms-win11.nix { };
            samfirm-js = nixpkgs.legacyPackages.${system}.callPackage ./packages/samfirm-js.nix { };
          }))
          {
            x86_64-linux = {
              #ida-pro = nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/ida-pro.nix { };
              odin4 = nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/odin4.nix { };
              outfox-alpha5 = nixpkgs.legacyPackages.x86_64-linux.callPackage ./packages/outfox-alpha5.nix { };
            };
          };
      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);
      checks = forAllSystems (system: {
        formatting = treefmtEval.${system}.config.build.check inputs.self;
      });

    };
}
