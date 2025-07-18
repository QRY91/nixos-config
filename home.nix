# QRY Home Manager Configuration
# User-specific settings and dotfiles for systematic engineering

{ config, lib, pkgs, inputs, ... }:

{
  # === Home Manager Settings ===
  home.username = "qry";
  home.homeDirectory = "/home/qry";
  home.stateVersion = "24.05";

  # === User Packages ===
  home.packages = with pkgs; [
    # === Terminal Tools ===
    zellij              # Terminal multiplexer
    starship            # Cross-shell prompt
    zoxide              # Smart cd replacement
    direnv              # Environment management

    # === Modern CLI Replacements ===
    bat                 # Better cat
    exa                 # Better ls
    ripgrep             # Better grep
    fd                  # Better find
    fzf                 # Fuzzy finder
    delta               # Better git diff
    dust                # Better du
    duf                 # Better df
    procs               # Better ps
    bottom              # Better top
    sd                  # Better sed
    choose              # Better awk
    hyperfine           # Benchmarking tool
    tokei               # Code statistics

    # === Development Tools ===
    lazygit             # Git TUI
    gitui               # Git TUI alternative
    gh                  # GitHub CLI
    glab                # GitLab CLI

    # === File Management ===
    ranger              # File manager
    lf                  # Lightweight file manager
    mc                  # Midnight Commander

    # === Text Processing ===
    jq                  # JSON processor
    yq                  # YAML processor
    fx                  # JSON viewer

    # === System Utilities ===
    htop                # Process viewer
    btop                # Modern process viewer
    iotop               # I/O monitoring
    nethogs             # Network monitoring
    bandwhich           # Network utilization

    # === Productivity ===
    obsidian            # Note taking
    zettlr              # Markdown editor

    # === Communication ===
    signal-desktop      # Secure messaging
    discord             # Gaming/dev communication

    # === Multimedia ===
    mpv                 # Video player
    yt-dlp              # YouTube downloader

    # === Archive Tools ===
    unzip
    p7zip

    # === Security ===
    age                 # Modern encryption
    pass                # Password store

    # === QRY Tools (placeholders for custom tools) ===
    # These will be replaced with actual custom packages
    # uroboro
    # wherewasi
    # doggowoof
  ];

  # === Shell Configuration ===
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    # Oh My Zsh configuration
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
        "golang"
        "python"
        "rust"
        "node"
        "npm"
        "yarn"
        "history"
        "colored-man-pages"
        "command-not-found"
        "extract"
        "z"
      ];
      theme = "";  # We use starship instead
    };

    # Shell aliases
    shellAliases = {
      # Modern CLI replacements
      ls = "exa --icons";
      ll = "exa -l --icons";
      la = "exa -la --icons";
      tree = "exa --tree --icons";
      cat = "bat";
      grep = "rg";
      find = "fd";
      du = "dust";
      df = "duf";
      ps = "procs";
      top = "btop";

      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";
      gd = "git diff";
      gco = "git checkout";
      gb = "git branch";
      glog = "git log --oneline --graph";

      # Docker shortcuts
      d = "docker";
      dc = "docker-compose";

      # Development shortcuts
      v = "nvim";
      vim = "nvim";

      # System shortcuts
      please = "sudo";
      cls = "clear";

      # QRY shortcuts
      projects = "cd ~/projects/qry";
      tools = "cd ~/projects/qry/tools";
      config = "cd ~/.config";

      # Nix shortcuts
      nrs = "sudo nixos-rebuild switch --flake .";
      nrt = "sudo nixos-rebuild test --flake .";
      nrb = "sudo nixos-rebuild boot --flake .";
      nfu = "nix flake update";

      # QRY methodology
      query = "echo 'What problem are we solving?'";
      refine = "echo 'How can we improve this solution?'";
      yield = "echo 'What have we learned and documented?'";

      # System maintenance
      cleanup = "sudo nix-collect-garbage -d && docker system prune -f";
      update = "sudo nixos-rebuild switch --upgrade-all";

      # Quick servers
      serve = "python3 -m http.server";
      myip = "curl -s ifconfig.me";

      # File operations
      mkdir = "mkdir -p";
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";

      # Network
      ping = "ping -c 5";

      # Productivity
      note = "obsidian";
      todo = "echo 'Use uroboro for task management'";
    };

    # Additional shell configuration
    initExtra = ''
      # QRY Environment Setup
      export QRY_ROOT="$HOME/projects/qry"
      export QRY_TOOLS="$QRY_ROOT/tools"
      export QRY_CONFIG="$HOME/.config/qry"
      export QRY_DATA="$HOME/.local/share/qry"

      # Create QRY directories
      mkdir -p "$QRY_CONFIG" "$QRY_DATA"

      # Starship prompt
      eval "$(starship init zsh)"

      # Zoxide (smart cd)
      eval "$(zoxide init zsh)"

      # Direnv
      eval "$(direnv hook zsh)"

      # FZF configuration
      export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
      export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
      export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

      # QRY development functions
      qry-new-project() {
        local name="$1"
        if [[ -z "$name" ]]; then
          echo "Usage: qry-new-project <name>"
          return 1
        fi

        mkdir -p "$QRY_ROOT/projects/$name"
        cd "$QRY_ROOT/projects/$name"
        git init
        echo "# $name" > README.md
        echo "Created new QRY project: $name"
      }

      qry-status() {
        echo "QRY Environment Status:"
        echo "Root: $QRY_ROOT"
        echo "Config: $QRY_CONFIG"
        echo "Data: $QRY_DATA"
        echo ""
        echo "Active projects:"
        ls -la "$QRY_ROOT/projects" 2>/dev/null || echo "No projects directory"
      }

      # Quick navigation
      cdq() {
        cd "$QRY_ROOT" || return 1
      }

      cdt() {
        cd "$QRY_TOOLS" || return 1
      }

      # History configuration
      HISTSIZE=10000
      SAVEHIST=10000
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_SAVE_NO_DUPS
      setopt SHARE_HISTORY

      # Key bindings
      bindkey '^R' fzf-history-widget
      bindkey '^T' fzf-file-widget
      bindkey '^[c' fzf-cd-widget
    '';
  };

  # === Starship Prompt ===
  programs.starship = {
    enable = true;
    settings = {
      format = "$all$character";

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };

      directory = {
        truncation_length = 3;
        fish_style_pwd_dir_length = 1;
      };

      git_branch = {
        format = "on [$symbol$branch]($style) ";
        symbol = "🌱 ";
      };

      git_status = {
        format = "([\\[$all_status$ahead_behind\\]]($style) )";
      };

      golang = {
        format = "via [$symbol($version )]($style)";
        symbol = "🐹 ";
      };

      python = {
        format = "via [$symbol$pyenv_prefix($version )(\($virtualenv\) )]($style)";
        symbol = "🐍 ";
      };

      rust = {
        format = "via [$symbol($version )]($style)";
        symbol = "🦀 ";
      };

      nodejs = {
        format = "via [$symbol($version )]($style)";
        symbol = "⬢ ";
      };

      package = {
        disabled = true;
      };

      custom.qry_env = {
        command = "echo QRY";
        when = "test -d $QRY_ROOT";
        format = "[$output]($style) ";
        style = "bold purple";
      };
    };
  };

  # === Git Configuration ===
  programs.git = {
    enable = true;
    userName = "QRY";
    userEmail = "qry@example.com";  # Update with actual email

    extraConfig = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
      push.autoSetupRemote = true;
      merge.conflictstyle = "diff3";
      diff.algorithm = "patience";

      # QRY-specific configuration
      user.signingkey = "";  # Add GPG key if desired
      commit.gpgsign = false;  # Enable if using GPG

      # Better diffs
      diff.tool = "vimdiff";
      merge.tool = "vimdiff";
    };

    aliases = {
      # Common shortcuts
      co = "checkout";
      br = "branch";
      ci = "commit";
      st = "status";
      unstage = "reset HEAD --";
      last = "log -1 HEAD";
      visual = "!gitk";

      # Advanced aliases
      lg = "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit";
      wip = "commit -am 'WIP: work in progress'";
      unwip = "reset HEAD~1";

      # QRY methodology aliases
      query = "log --oneline -10";
      refine = "add -A && commit -m 'refine: systematic improvements'";
      yield = "log --oneline --since='1 week ago'";
    };

    ignores = [
      # System files
      ".DS_Store"
      "Thumbs.db"

      # IDE files
      ".vscode/"
      ".idea/"
      "*.swp"
      "*.swo"
      "*~"

      # Build artifacts
      "target/"
      "dist/"
      "build/"
      "node_modules/"
      "*.pyc"
      "__pycache__/"

      # QRY specific
      ".qry-cache/"
      "qry-temp/"
    ];
  };

  # === Neovim Configuration ===
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    extraConfig = ''
      " QRY Neovim Configuration
      set number
      set relativenumber
      set tabstop=4
      set shiftwidth=4
      set expandtab
      set smartindent
      set wrap
      set smartcase
      set noswapfile
      set nobackup
      set undodir=~/.vim/undodir
      set undofile
      set incsearch
      set scrolloff=8
      set colorcolumn=80
      set signcolumn=yes

      " QRY-specific settings
      set textwidth=80
      colorscheme default

      " Key mappings
      let mapleader = " "
      nnoremap <leader>w :w<CR>
      nnoremap <leader>q :q<CR>
      nnoremap <leader>e :Ex<CR>

      " QRY methodology mappings
      nnoremap <leader>rq :echo "Query: What problem are we solving?"<CR>
      nnoremap <leader>rr :echo "Refine: How can we improve this?"<CR>
      nnoremap <leader>ry :echo "Yield: What have we learned?"<CR>
    '';
  };

  # === Terminal Multiplexer (Zellij) ===
  programs.zellij = {
    enable = true;
    settings = {
      default_shell = "zsh";
      pane_frames = false;
      theme = "default";
      default_layout = "compact";

      keybinds = {
        normal = {
          "bind \"Ctrl g\"" = { SwitchToMode = "locked"; };
          "bind \"Ctrl p\"" = { SwitchToMode = "pane"; };
          "bind \"Ctrl t\"" = { SwitchToMode = "tab"; };
          "bind \"Ctrl s\"" = { SwitchToMode = "scroll"; };
          "bind \"Ctrl o\"" = { SwitchToMode = "session"; };
          "bind \"Ctrl h\"" = { SwitchToMode = "move"; };
          "bind \"Ctrl n\"" = { SwitchToMode = "resize"; };
          "bind \"Alt n\"" = { NewPane = "Down"; };
          "bind \"Alt h\" \"Alt Left\"" = { MoveFocusOrTab = "Left"; };
          "bind \"Alt l\" \"Alt Right\"" = { MoveFocusOrTab = "Right"; };
          "bind \"Alt j\" \"Alt Down\"" = { MoveFocus = "Down"; };
          "bind \"Alt k\" \"Alt Up\"" = { MoveFocus = "Up"; };
        };
      };
    };
  };

  # === Development Environment ===
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  # === FZF Configuration ===
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  # === GPG Configuration ===
  programs.gpg = {
    enable = true;
    settings = {
      default-key = "";  # Set your GPG key ID
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 3600;
    enableSshSupport = true;
  };

  # === XDG Directories ===
  xdg = {
    enable = true;

    userDirs = {
      enable = true;
      createDirectories = true;
      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
      templates = "$HOME/Templates";
      publicShare = "$HOME/Public";
    };

    configFile = {
      "qry/config.toml".text = ''
        # QRY Configuration
        [environment]
        root = "~/projects/qry"
        tools = "~/projects/qry/tools"
        config = "~/.config/qry"
        data = "~/.local/share/qry"

        [methodology]
        query = "What problem are we solving?"
        refine = "How can we improve this solution?"
        yield = "What have we learned and documented?"

        [tools]
        uroboro = "Work documentation and acknowledgment system"
        wherewasi = "Context generation for AI collaboration"
        doggowoof = "Cost tracking and optimization"
      '';
    };
  };

  # === User Services ===
  systemd.user.services.qry-environment = {
    Unit = {
      Description = "QRY User Environment Setup";
      After = [ "graphical-session.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'mkdir -p $HOME/.config/qry $HOME/.local/share/qry'";
      RemainAfterExit = true;
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # === Environment Variables ===
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";

    # QRY environment
    QRY_ROOT = "$HOME/projects/qry";
    QRY_TOOLS = "$HOME/projects/qry/tools";
    QRY_CONFIG = "$HOME/.config/qry";
    QRY_DATA = "$HOME/.local/share/qry";

    # Development
    GOPATH = "$HOME/go";
    CARGO_HOME = "$HOME/.cargo";
    RUSTUP_HOME = "$HOME/.rustup";

    # History
    HISTCONTROL = "ignoreboth";
    HISTSIZE = "10000";
    HISTFILESIZE = "20000";
  };

  # === File Associations ===
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "text/plain" = "nvim.desktop";
      "text/markdown" = "obsidian.desktop";
      "application/pdf" = "evince.desktop";
      "image/png" = "eog.desktop";
      "image/jpeg" = "eog.desktop";
      "video/mp4" = "mpv.desktop";
      "audio/mpeg" = "mpv.desktop";
    };
  };

  # === Let Home Manager manage itself ===
  programs.home-manager.enable = true;
}
