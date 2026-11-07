{
  description = "Modular NixOS + Home Manager config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/25.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    driftwm = {
      url = "github:malbiruk/driftwm";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Claude Desktop for Linux. Intentionally NOT following our nixpkgs:
    # it needs a newer Electron than the 25.11 release ships.
    claude-desktop.url = "github:patrickjaja/claude-desktop-extra";
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
