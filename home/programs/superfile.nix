{ pkgs, ... }:

{
  home.file.".config/superfile/config.toml" = {
    force = true;
    text = ''
      # superfile config — only override what we need, spf merges with defaults
      theme                   = "catppuccin-mocha"
      nerdfont                = true
      transparent_background  = false
      default_open_file_preview = true
      default_directory       = "."
      auto_check_update       = false
      editor                  = "nano"
      cd_on_quit              = false
      file_size_use_si        = false
    '';
  };
}
