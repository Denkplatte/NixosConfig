# NixosConfig

Flake-based NixOS + Home Manager config (driftwm, waybar, greetd, hotline-miami theme).

## Layout

```
flake.nix                 inputs + list of hosts (one line per machine)
lib/mkHost.nix            builds a host from the pieces below
hosts/<Hostname>/
  default.nix             machine-specific: bootloader, GPU, optional desktops, stateVersion
  hardware-configuration.nix
  home.nix                (optional) machine-specific Home Manager bits
modules/nixos/            shared system modules
  core/                   nix settings, locale, users, fonts, base packages
  desktop/                wayland, greetd login, driftwm, apps, Claude Desktop, gnome/kde (opt-in)
  hardware/               nvidia (opt-in via my.nvidia.enable)
  services/               audio, network/vpn, printing
home/                     shared Home Manager config
  desktop/                driftwm, waybar, launcher, mime types, desktop entries
  programs/               kitty, yazi, superfile
theme/                    colour palette + helpers (passed to modules as `theme`)
```

Every module receives `hostname`, `username`, `theme` and `inputs` as arguments.

## Rebuild

```bash
sudo nixos-rebuild switch --flake .#Denkplatte
```

## Add a new machine

1. Install NixOS, then clone this repo on the new machine.
2. `mkdir hosts/<Hostname>` and copy `/etc/nixos/hardware-configuration.nix` into it.
3. Create `hosts/<Hostname>/default.nix` (copy `hosts/Denkplatte/default.nix` and adjust
   bootloader, `my.nvidia`, and `system.stateVersion` to the version you installed).
4. Add a line to `flake.nix`:
   `<Hostname> = mkHost { hostname = "<Hostname>"; username = "<you>"; };`
5. `git add .` (flakes only see tracked files), then
   `sudo nixos-rebuild switch --flake .#<Hostname>`.
