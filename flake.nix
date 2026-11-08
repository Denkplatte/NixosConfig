{
  description = "Modular NixOS + Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";  # available as `pkgs-unstable`

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    driftwm = {
      url = "github:malbiruk/driftwm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Claude Desktop for Linux. Needs a newer Electron than 25.11 ships,
    # so it shares our unstable nixpkgs instead of downloading its own.
    claude-desktop = {
      url = "github:patrickjaja/claude-desktop-extra";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };

  outputs = inputs:
    let
      mkHost = import ./lib/mkHost.nix { inherit inputs; };
    in
    {
      # Add a new machine: create hosts/<Hostname>/ and add one line here.
      nixosConfigurations = {
        Denkplatte = mkHost { hostname = "Denkplatte"; username = "las"; };
      };
    };
}
