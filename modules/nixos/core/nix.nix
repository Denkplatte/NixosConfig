{ hostname, ... }:

{
  networking.hostName = hostname;

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # Run unpatched dynamically linked binaries (default library set includes libstdc++).
  programs.nix-ld.enable = true;
}
