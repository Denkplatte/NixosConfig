{ pkgs, ... }:

let
  t = import ../../theme/hotline-miami.nix;
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
  # Full Hotline Miami palette applied to every yazi component.
  # We set explicit fg colours on file list items — this also fixes the kitty
  # icon-size bug that appears when fg is inherited from the terminal.
  home.file.".config/yazi/theme.toml".text = ''
    # ── manager ─────────────────────────────────────────────────────────────────
    [mgr]
    cwd = { fg = "${t.teal}", bold = true }

    # hovered file (cursor row)
    hovered         = { fg = "${t.bg}",     bg = "${t.pink}",   bold = true }
    preview_hovered = { fg = "${t.bg}",     bg = "${t.pinkDim}" }

    # find matches (/ search)
    find_keyword  = { fg = "${t.yellow}", bold = true, italic = true }
    find_position = { fg = "${t.pink}",   bold = true }

    # marked/selected files
    marker_selected = { fg = "${t.green}",  bg = "${t.green}" }
    marker_copied   = { fg = "${t.yellow}", bg = "${t.yellow}" }
    marker_cut      = { fg = "${t.pink}",   bg = "${t.pink}" }

    # tab titles
    tab_active   = { fg = "${t.bg}",     bg = "${t.pink}", bold = true }
    tab_inactive = { fg = "${t.fgMuted}", bg = "${t.bgAlt}" }
    tab_width    = 1

    # count badges
    count_selected = { fg = "${t.bg}", bg = "${t.green}", bold = true }
    count_copied   = { fg = "${t.bg}", bg = "${t.yellow}", bold = true }
    count_cut      = { fg = "${t.bg}", bg = "${t.pink}",   bold = true }

    border_symbol = "│"
    border_style  = { fg = "${t.pinkDim}" }

    # ── mode indicator (bottom-right corner) ────────────────────────────────────
    [mode]
    normal_main = { fg = "${t.bg}", bg = "${t.teal}",   bold = true }
    normal_alt  = { fg = "${t.teal}",  bg = "${t.bgAlt}" }
    select_main = { fg = "${t.bg}", bg = "${t.pink}",   bold = true }
    select_alt  = { fg = "${t.pink}",  bg = "${t.bgAlt}" }
    unset_main  = { fg = "${t.bg}", bg = "${t.yellow}", bold = true }
    unset_alt   = { fg = "${t.yellow}", bg = "${t.bgAlt}" }

    # ── status bar (bottom) ──────────────────────────────────────────────────────
    [status]
    overall       = { fg = "${t.fg}",     bg = "${t.bgAlt}" }
    filename      = { fg = "${t.fg}",     bold = true }
    filename_sep  = { fg = "${t.pinkDim}" }
    filesize      = { fg = "${t.teal}" }
    filetype      = { fg = "${t.fgMuted}" }
    permissions   = { fg = "${t.purple}" }
    owner         = { fg = "${t.fgMuted}" }
    mtime         = { fg = "${t.fgMuted}" }
    link          = { fg = "${t.teal}",   italic = true }
    sep_left      = { open = "", close = "" }
    sep_right     = { open = "", close = "" }

    # ── header bar (top) ─────────────────────────────────────────────────────────
    [header]
    host     = { fg = "${t.pink}",  bold = true }
    user     = { fg = "${t.teal}",  bold = true }
    cwd      = { fg = "${t.fg}" }
    sep_left = { open = "", close = "" }

    # ── file icons & colours ─────────────────────────────────────────────────────
    # Setting fg here is what fixes the kitty icon-size bug — the colour signals
    # to kitty that these spans should match the surrounding text metrics.
    [filetype]
    rules = [
      # directories
      { is = "dir",  fg = "${t.teal}",    bold = true },
      # executables
      { is = "exec", fg = "${t.green}" },
      # symlinks
      { is = "link", fg = "${t.purple}" },
      # orphaned symlinks
      { is = "orphan", fg = "${t.pink}", underline = true },
      # hidden dotfiles
      { name = ".*", fg = "${t.fgMuted}" },
      # images
      { mime = "image/*", fg = "${t.yellow}" },
      # video
      { mime = "video/*", fg = "${t.orange}" },
      # audio
      { mime = "audio/*", fg = "${t.orange}" },
      # archives
      { mime = "application/zip",            fg = "${t.pink}" },
      { mime = "application/x-tar",          fg = "${t.pink}" },
      { mime = "application/x-bzip2",        fg = "${t.pink}" },
      { mime = "application/x-7z-compressed",fg = "${t.pink}" },
      { mime = "application/x-rar",          fg = "${t.pink}" },
      { mime = "application/gzip",           fg = "${t.pink}" },
      # text / code
      { mime = "text/*",       fg = "${t.fg}" },
      { mime = "application/json", fg = "${t.teal}" },
      # fallback
      { name = "*", fg = "${t.fg}" },
    ]

    # ── selection & input dialogs ────────────────────────────────────────────────
    [select]
    border   = { fg = "${t.pinkDim}" }
    active   = { fg = "${t.pink}", bold = true }
    inactive = { fg = "${t.fgMuted}" }

    [input]
    border   = { fg = "${t.pinkDim}" }
    title    = { fg = "${t.teal}", bold = true }
    value    = { fg = "${t.fg}" }
    selected = { fg = "${t.bg}", bg = "${t.pink}" }

    # ── completion popup ─────────────────────────────────────────────────────────
    [completion]
    border    = { fg = "${t.pinkDim}" }
    active    = { fg = "${t.pink}", bold = true }
    inactive  = { fg = "${t.fgMuted}" }

    # ── task manager panel ───────────────────────────────────────────────────────
    [tasks]
    border  = { fg = "${t.pinkDim}" }
    title   = { fg = "${t.teal}", bold = true }
    hovered = { fg = "${t.bg}", bg = "${t.pink}", bold = true }

    # ── help overlay ─────────────────────────────────────────────────────────────
    [help]
    on      = { fg = "${t.yellow}" }
    exec    = { fg = "${t.teal}" }
    desc    = { fg = "${t.fg}" }
    hovered = { bg = "${t.bgAlt}", bold = true }
    footer  = { fg = "${t.fgMuted}", bg = "${t.bgAlt}" }

    # ── notify toasts ────────────────────────────────────────────────────────────
    [notify]
    title_info  = { fg = "${t.teal}" }
    title_warn  = { fg = "${t.yellow}" }
    title_error = { fg = "${t.pink}" }
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
