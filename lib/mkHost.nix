# Builds one NixOS system from:
#   hosts/<hostname>/default.nix   machine-specific settings (required)
#   hosts/<hostname>/home.nix      machine-specific Home Manager settings (optional)
#   modules/nixos                  shared system modules
#   home                           shared Home Manager config
{ inputs }:

{ hostname, username, system ? "x86_64-linux" }:

let
  inherit (inputs.nixpkgs) lib;
  hostDir  = ../hosts + "/${hostname}";
  hostHome = hostDir + "/home.nix";
  theme    = import ../theme { inherit lib; };
  args     = { inherit inputs hostname username theme; };
in
lib.nixosSystem {
  inherit system;
  specialArgs = args;
  modules = [
    hostDir
    ../modules/nixos
    inputs.home-manager.nixosModules.home-manager
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        # Existing unmanaged dotfiles get renamed instead of blocking activation.
        backupFileExtension = "hm-bak";
        extraSpecialArgs = args;
        users.${username}.imports =
          [ ../home ] ++ lib.optional (builtins.pathExists hostHome) hostHome;
      };
    }
  ];
}
