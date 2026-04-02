{ pkgs, ... }:

let
  otter-launcher = pkgs.rustPlatform.buildRustPackage {
    pname = "otter-launcher";
    version = "0.6.7";

    src = pkgs.fetchFromGitHub {
      owner = "kuokuo123";
      repo = "otter-launcher";
      rev = "v0.6.7";
      hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # placeholder
    };

    cargoHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="; # placeholder
  };
in
{
  environment.systemPackages = [ otter-launcher ];
}
