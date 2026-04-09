{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  sqlite,
}:

buildDotnetModule (finalAttrs: {
  pname = "mcgalaxy";
  version = "1.9.5.3";

  src = fetchFromGitHub {
    owner = "ClassiCube";
    repo = "MCGalaxy";
    tag = finalAttrs.version;
    hash = "sha256-dInKW6y8S0mzac2cAUg0RMrfaEThgNoyNTZU66TGIyA=";
  };

  projectFile = "CLI/MCGalaxyCLI_dotnet8.csproj";

  nugetDeps = ./mcgalaxy_deps.json; # nix-build -E "with import <nixpkgs> {}; (callPackage ./mcgalaxy.nix {}).fetch-deps" && ./result

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  runtimeDeps = [ sqlite ];
})
