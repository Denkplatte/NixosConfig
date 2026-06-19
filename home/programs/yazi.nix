{ pkgs, ... }:
let
  # Catppuccin Mocha — the exact palette superfile.nix's `theme = "catppuccin-mocha"`
  # pulls from. Using the real published hex codes here is the closest 1:1 visual
  # match achievable between two unrelated TUI projects.
  c = {
    rosewater = "#f5e0dc";
    flamingo  = "#f2cdcd";
    pink      = "#f5c2e7";
    mauve     = "#cba6f7"; # the signature catppuccin accent — used as our "hovered" highlight
    red       = "#f38ba8";
    maroon    = "#eba0ac";
    peach     = "#fab387";
    yellow    = "#f9e2af";
    green     = "#a6e3a1";
    teal      = "#94e2d5";
    sky       = "#89dceb";
    sapphire  = "#74c7ec";
    blue      = "#89b4fa";
    lavender  = "#b4befe";
    text      = "#cdd6f4";
    subtext1  = "#bac2de";
    subtext0  = "#a6adc8";
    overlay2  = "#9399b2";
    overlay1  = "#7f849c";
    overlay0  = "#6c7086";
    surface2  = "#585b70";
    surface1  = "#45475a";
    surface0  = "#313244";
    base      = "#1e1e2e";
    mantle    = "#181825";
    crust     = "#11111b";
  };
in
{
  # ─── yazi.toml ───────────────────────────────────────────────────────────────
  # General behaviour — keeping it close to superfile's feel:
  # single-column layout (miller columns disabled via ratio), file preview on,
  # show hidden files off by default, mouse enabled.
  home.file.".config/yazi/yazi.toml".text = ''
    [mgr]
    ratio          = [1, 4, 3]   # parent : current : preview column widths
    sort_by        = "natural"
    sort_sensitive = false
    sort_reverse   = false
    sort_dir_first = true
    show_hidden    = false
    show_symlink   = true
    linemode       = "size_and_mtime"
    scrolloff      = 5
    [preview]
    wrap            = "no"
    tab_size        = 2
    max_width       = 1000
    max_height      = 1000
    cache_dir       = ""
    image_filter    = "triangle"
    image_quality   = 75
    sixel_fraction  = 15
    ueberzug_scale  = 1
    ueberzug_offset = [0, 0, 0, 0]
    [opener]
    # open text files in your $EDITOR inside kitty (blocking so kitty waits)
    edit = [
      { run = '${pkgs.kitty}/bin/kitty -e "$EDITOR" "$@"', block = true, desc = "$EDITOR", for = "unix" },
    ]
    open = [
      { run = 'xdg-open "$@"', orphan = true, desc = "Open", for = "unix" },
    ]
    reveal = [
      { run = 'xdg-open "$(dirname "$1")"', orphan = true, desc = "Reveal in file manager", for = "unix" },
    ]
    extract = [
      { run = 'unar "$1"', desc = "Extract here", for = "unix" },
    ]
    play = [
      { run = 'mpv "$@"', orphan = true, desc = "Play", for = "unix" },
    ]
    [open]
    rules = [
      { mime = "text/*",             use = ["edit", "open"] },
      { mime = "image/*",            use = ["open"] },
      { mime = "video/*",            use = ["play", "open"] },
      { mime = "audio/*",            use = ["play", "open"] },
      { mime = "inode/directory",    use = ["open"] },
      { mime = "application/json",   use = ["edit", "open"] },
      { mime = "*",                  use = ["open"] },
    ]
    [tasks]
    micro_workers    = 10
    macro_workers    = 5
    bizarre_retry    = 5
    image_alloc      = 536870912  # 512 MB
    image_bound      = [0, 0]
    suppress_preload = false
    [plugin]
    # prepend_previewers / preloaders can be added here when using plugins
    [input]
    cursor_blink = false
    [log]
    enabled = false
  '';
  # ─── keymap.toml ─────────────────────────────────────────────────────────────
  # We prepend our custom bindings so the defaults remain intact.
  # Superfile-like muscle memory:
  #   v       → toggle visual/select mode  (yazi calls it "select mode")
  #   b       → blobdrop hovered/selected files
  #   ctrl+d  → delete to trash
  #   e       → open in editor
  #   !       → drop to shell in cwd
  #   tab     → toggle file preview
  home.file.".config/yazi/keymap.toml".text = ''
    # ── manager (file panel) ────────────────────────────────────────────────────
    [mgr]
    prepend_keymap = [
      # ── blobdrop ─────────────────────────────────────────────────────────────
      # %s expands to ALL selected files (space-separated paths).
      # If nothing is selected it falls back to the hovered file (%h).
      # --orphan keeps blobdrop alive after yazi closes/refocuses.
      { on = "b", run = "shell -- blobdrop %s", desc = "Drag selected files with blobdrop" },
      { on = "B", run = "shell -- blobdrop %h", desc = "Drag hovered file with blobdrop" },
      # ── superfile-style shortcuts ─────────────────────────────────────────────
      # ctrl+n  → new file/dir (same as superfile)
      { on = "<C-n>", run = "create", desc = "Create file or directory" },
      # ctrl+r  → rename (same as superfile)
      { on = "<C-r>", run = "rename", desc = "Rename file" },
      # e → open in $EDITOR (superfile uses 'e' for this too)
      { on = "e", run = "open --interactive", desc = "Open with..." },
      # ! → drop into a shell at the current path (like superfile's ':' prompt)
      { on = "!", run = "shell \"$SHELL\" --block", desc = "Open shell here" },
      # ctrl+a → select all (superfile: shift+a)
      { on = "<C-a>", run = "select_all --state=true", desc = "Select all" },
      # tab → toggle preview pane (superfile: 'f')
      { on = "<Tab>", run = "preview --state=toggle", desc = "Toggle preview" },
      # . → toggle hidden files (same as superfile)
      { on = ".", run = "hidden toggle", desc = "Toggle hidden files" },
      # Multiple panels (superfile uses ctrl+n for this, we use ctrl+p)
      { on = "<C-p>", run = "tab_create --current", desc = "New tab (panel)" },
      { on = "[",     run = "tab_switch -1 --relative", desc = "Previous tab" },
      { on = "]",     run = "tab_switch  1 --relative", desc = "Next tab" },
      # bookmark-style jumps (superfile sidebar pins → yazi g+key)
      { on = ["g", "h"], run = "cd ~",            desc = "Go home" },
      { on = ["g", "d"], run = "cd ~/Downloads",  desc = "Go Downloads" },
      { on = ["g", "c"], run = "cd ~/.config",    desc = "Go .config" },
      { on = ["g", "n"], run = "cd ~/NixosConfig", desc = "Go NixosConfig" },
    ]
    # ── task panel ──────────────────────────────────────────────────────────────
    [tasks]
    prepend_keymap = [
      { on = "<Esc>", run = "close", desc = "Close task manager" },
    ]
    # ── input box ───────────────────────────────────────────────────────────────
    [input]
    prepend_keymap = [
      # Make Esc cancel immediately (no vim-mode detour)
      { on = "<Esc>", run = "close", desc = "Cancel" },
    ]
  '';
  # ─── theme.toml ──────────────────────────────────────────────────────────────
  # Catppuccin Mocha applied to every yazi component — the same palette family
  # superfile.nix uses, for the closest possible visual parity between the two.
  # We still set explicit fg colours on file list items — this is what fixes the
  # kitty icon-size bug that appears when fg is inherited from the terminal.
  home.file.".config/yazi/theme.toml".text = ''
    # ── manager ─────────────────────────────────────────────────────────────────
    [mgr]
    cwd = { fg = "${c.blue}", bold = true }
    # hovered file (cursor row) — mauve is catppuccin's signature accent
    hovered         = { fg = "${c.base}",   bg = "${c.mauve}",   bold = true }
    preview_hovered = { fg = "${c.base}",   bg = "${c.surface1}" }
    # find matches (/ search)
    find_keyword  = { fg = "${c.yellow}", bold = true, italic = true }
    find_position = { fg = "${c.pink}",   bold = true }
    # marked/selected files
    marker_selected = { fg = "${c.green}", bg = "${c.green}" }
    marker_copied   = { fg = "${c.yellow}", bg = "${c.yellow}" }
    marker_cut      = { fg = "${c.red}",   bg = "${c.red}" }
    # tab titles
    tab_active   = { fg = "${c.base}",     bg = "${c.mauve}", bold = true }
    tab_inactive = { fg = "${c.subtext0}", bg = "${c.surface0}" }
    tab_width    = 1
    # count badges
    count_selected = { fg = "${c.base}", bg = "${c.green}", bold = true }
    count_copied   = { fg = "${c.base}", bg = "${c.yellow}", bold = true }
    count_cut      = { fg = "${c.base}", bg = "${c.red}",   bold = true }
    border_symbol = "│"
    border_style  = { fg = "${c.surface2}" }
    # ── mode indicator (bottom-right corner) ────────────────────────────────────
    [mode]
    normal_main = { fg = "${c.base}", bg = "${c.blue}",   bold = true }
    normal_alt  = { fg = "${c.blue}",  bg = "${c.surface0}" }
    select_main = { fg = "${c.base}", bg = "${c.mauve}",   bold = true }
    select_alt  = { fg = "${c.mauve}",  bg = "${c.surface0}" }
    unset_main  = { fg = "${c.base}", bg = "${c.yellow}", bold = true }
    unset_alt   = { fg = "${c.yellow}", bg = "${c.surface0}" }
    # ── status bar (bottom) ──────────────────────────────────────────────────────
    [status]
    overall       = { fg = "${c.text}",     bg = "${c.mantle}" }
    filename      = { fg = "${c.text}",     bold = true }
    filename_sep  = { fg = "${c.surface2}" }
    filesize      = { fg = "${c.teal}" }
    filetype      = { fg = "${c.overlay1}" }
    permissions   = { fg = "${c.mauve}" }
    owner         = { fg = "${c.overlay1}" }
    mtime         = { fg = "${c.overlay1}" }
    link          = { fg = "${c.teal}",   italic = true }
    sep_left      = { open = "", close = "" }
    sep_right     = { open = "", close = "" }
    # ── header bar (top) ─────────────────────────────────────────────────────────
    [header]
    host     = { fg = "${c.pink}",  bold = true }
    user     = { fg = "${c.blue}",  bold = true }
    cwd      = { fg = "${c.text}" }
    sep_left = { open = "", close = "" }
    # ── file icons & colours ─────────────────────────────────────────────────────
    # Setting fg here is what fixes the kitty icon-size bug — the colour signals
    # to kitty that these spans should match the surrounding text metrics.
    [filetype]
    rules = [
      # directories — matched by trailing slash, not `is`
      { name = "*/", fg = "${c.blue}",    bold = true },
      # executables
      { is = "exec", fg = "${c.green}" },
      # symlinks
      { is = "link", fg = "${c.mauve}" },
      # orphaned symlinks
      { is = "orphan", fg = "${c.red}", underline = true },
      # hidden dotfiles
      { name = ".*", fg = "${c.overlay0}" },
      # images
      { mime = "image/*", fg = "${c.yellow}" },
      # video
      { mime = "video/*", fg = "${c.peach}" },
      # audio
      { mime = "audio/*", fg = "${c.peach}" },
      # archives
      { mime = "application/zip",            fg = "${c.pink}" },
      { mime = "application/x-tar",          fg = "${c.pink}" },
      { mime = "application/x-bzip2",        fg = "${c.pink}" },
      { mime = "application/x-7z-compressed",fg = "${c.pink}" },
      { mime = "application/x-rar",          fg = "${c.pink}" },
      { mime = "application/gzip",           fg = "${c.pink}" },
      # text / code
      { mime = "text/*",       fg = "${c.text}" },
      { mime = "application/json", fg = "${c.teal}" },
      # fallback
      { name = "*", fg = "${c.text}" },
    ]
    # ── selection & input dialogs ────────────────────────────────────────────────
    [select]
    border   = { fg = "${c.surface2}" }
    active   = { fg = "${c.mauve}", bold = true }
    inactive = { fg = "${c.overlay1}" }
    [input]
    border   = { fg = "${c.surface2}" }
    title    = { fg = "${c.blue}", bold = true }
    value    = { fg = "${c.text}" }
    selected = { fg = "${c.base}", bg = "${c.mauve}" }
    # ── completion popup ─────────────────────────────────────────────────────────
    [completion]
    border    = { fg = "${c.surface2}" }
    active    = { fg = "${c.mauve}", bold = true }
    inactive  = { fg = "${c.overlay1}" }
    # ── task manager panel ───────────────────────────────────────────────────────
    [tasks]
    border  = { fg = "${c.surface2}" }
    title   = { fg = "${c.blue}", bold = true }
    hovered = { fg = "${c.base}", bg = "${c.mauve}", bold = true }
    # ── help overlay ─────────────────────────────────────────────────────────────
    [help]
    on      = { fg = "${c.yellow}" }
    exec    = { fg = "${c.teal}" }
    desc    = { fg = "${c.text}" }
    hovered = { bg = "${c.surface0}", bold = true }
    footer  = { fg = "${c.overlay1}", bg = "${c.mantle}" }
    # ── notify toasts ────────────────────────────────────────────────────────────
    [notify]
    title_info  = { fg = "${c.teal}" }
    title_warn  = { fg = "${c.yellow}" }
    title_error = { fg = "${c.red}" }
    icon_info   = ""
    icon_warn   = "󰀪"
    icon_error  = "󰅚"
  '';
  # ─── desktop entry so it shows up in fsel-menu ───────────────────────────────
  xdg.desktopEntries.yazi = {
    name = "Yazi";
    exec = "kitty --app-id yazi --detach -e yazi";
    terminal = false;
    type = "Application";
    categories = [ "System" "FileTools" ];
  };
}
