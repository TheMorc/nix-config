{
  buildDotnetModule,
  dotnetCorePackages,
  fetchFromGitHub,
  sqlite,
}:

buildDotnetModule (finalAttrs: {
  pname = "mcgalaxy";
  version = "1.9.5.4";

  src = fetchFromGitHub {
    owner = "ClassiCube";
    repo = "MCGalaxy";
    tag = finalAttrs.version;
    hash = "sha256-4xdPGDfkUxkYFRPMmW0zpMgC7PjY052ND57RpU+6z50=";
  };

  projectFile = "CLI/MCGalaxyCLI_dotnet8.csproj";

  nugetDeps = ./mcgalaxy_deps.json; # nix-build -E "with import <nixpkgs> {}; (callPackage ./mcgalaxy.nix {}).fetch-deps" && ./result

  dotnet-sdk = dotnetCorePackages.sdk_8_0;
  dotnet-runtime = dotnetCorePackages.runtime_8_0;

  runtimeDeps = [ sqlite ];
})
