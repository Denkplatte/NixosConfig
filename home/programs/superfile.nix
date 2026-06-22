# home/programs/superfile.nix
{ pkgs, ... }:
{
  home.file.".config/superfile/config.toml" = {
    force = true;
    text = ''
      theme                   = "catppuccin-mocha"
      nerdfont                = true
      transparent_background  = false
      default_open_file_preview = false
      default_directory       = "."
      auto_check_update       = false
      editor                  = "nano"
      cd_on_quit              = false
      file_size_use_si        = false
      show_image_preview      = false

    '';
  };
}
