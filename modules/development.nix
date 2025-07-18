# QRY Development Environment
# Core tools for systematic engineering and AI-assisted development

{ config, lib, pkgs, inputs, ... }:

{
  # === Programming Languages ===
  environment.systemPackages = with pkgs; [
    # Go toolchain (primary language for QRY tools)
    go
    gofumpt          # Go formatter
    golangci-lint    # Go linter
    delve            # Go debugger
    air              # Go hot reload

    # Python ecosystem
    python3
    python3Packages.pip
    python3Packages.virtualenv
    python3Packages.poetry
    python3Packages.black
    python3Packages.isort
    python3Packages.mypy
    python3Packages.pytest
    python3Packages.requests
    python3Packages.flask
    python3Packages.fastapi
    python3Packages.pandas
    python3Packages.numpy

    # Node.js ecosystem
    nodejs_20
    nodePackages.npm
    nodePackages.yarn
    nodePackages.pnpm
    nodePackages.typescript
    nodePackages.typescript-language-server
    nodePackages.prettier
    nodePackages.eslint

    # Rust toolchain
    rustc
    cargo
    rustfmt
    rust-analyzer
    clippy

    # C/C++ for systems work
    gcc
    gdb
    valgrind
    cmake
    ninja

    # Shell scripting
    shellcheck
    shfmt

    # Database tools
    sqlite
    postgresql
    redis

    # === Editors and IDEs ===
    neovim
    vscode

    # === Terminal Environment ===
    zellij           # Terminal multiplexer (modern tmux)
    starship         # Cross-shell prompt

    # Modern CLI replacements
    bat              # Better cat
    exa              # Better ls
    ripgrep          # Better grep
    fd               # Better find
    fzf              # Fuzzy finder
    zoxide           # Better cd

    # Git tools
    git
    git-lfs
    gh               # GitHub CLI
    gitui            # Git TUI
    delta            # Better git diff

    # Network tools
    httpie
    curl
    wget

    # File processing
    jq               # JSON processor
    yq               # YAML processor

    # Documentation
    pandoc

    # Container tools
    docker
    docker-compose

    # === QRY Custom Tools ===
    # Note: These will be custom packages we'll create
    # (callPackage ../packages/uroboro.nix {})
    # (callPackage ../packages/wherewasi.nix {})
    # (callPackage ../packages/doggowoof.nix {})

    # === System Development ===
    strace
    ltrace
    lsof
    tcpdump
    wireshark

    # Performance analysis
    perf-tools
    flamegraph

    # === Build Tools ===
    gnumake
    meson
    ninja

    # === Package Management ===
    nix-index        # Search nix packages
    nix-tree         # Explore nix dependencies
    nixpkgs-fmt      # Format nix files

    # === Monitoring and Debugging ===
    htop
    btop
    iotop
    nethogs
    bandwhich

    # === Security Tools ===
    nmap
    netcat

    # === Documentation and Note-taking ===
    obsidian         # Knowledge management
    zettlr           # Markdown editor

    # === Productivity ===
    tmux             # Backup multiplexer
    ranger           # File manager

    # === Development Utilities ===
    watchexec        # File watcher
    entr             # File watcher
    just             # Command runner

    # === Language Servers ===
    gopls            # Go LSP
    pyright          # Python LSP
    rust-analyzer    # Rust LSP
    nil              # Nix LSP

    # === Database Development ===
    pgcli            # PostgreSQL CLI
    sqlite-utils     # SQLite utilities

    # === API Development ===
    postman          # API testing
    insomnia         # API testing

    # === Text Processing ===
    sd               # Better sed
    choose           # Better awk

    # === File Compression ===
    xz
    gzip

    # === System Information ===
    neofetch
    fastfetch

    # === Network Analysis ===
    ngrep

    # === Process Management ===
    procs            # Better ps

    # === System Monitoring ===
    dust             # Better du
    duf              # Better df

    # === Version Control ===
    mercurial
    subversion

    # === Backup Tools ===
    borgbackup
    restic

    # === Cloud Development ===
    terraform
    kubectl

    # === Documentation Generation ===
    mdbook

    # === Testing ===
    k6               # Load testing

    # === Benchmarking ===
    hyperfine        # Command-line benchmarking

    # === File Synchronization ===
    syncthing

    # === Remote Development ===
    mosh             # Mobile shell

    # === System Administration ===
    ansible

    # === Container Development ===
    podman
    buildah
    skopeo

    # === Service Mesh ===
    istioctl

    # === Image Processing ===
    imagemagick

    # === Hex Editors ===
    hexyl

    # === JSON/YAML Tools ===
    fx               # JSON viewer

    # === Log Analysis ===
    lnav             # Log navigator

    # === System Profiling ===
    sysstat

    # === Network Utilities ===
    socat

    # === File Comparison ===
    diff-so-fancy

    # === Terminal Recording ===
    asciinema

    # === Code Quality ===
    codespell

    # === System Resources ===
    stress
    stress-ng

    # === Development Servers ===
    caddy

    # === Protocol Buffers ===
    protobuf

    # === Message Queues ===
    redis

    # === Time Tracking ===
    # Note: This is where uroboro will fit in

    # === Context Management ===
    # Note: This is where wherewasi will fit in

    # === System Monitoring ===
    # Note: This is where doggowoof will fit in
  ];

  # === Programming Language Configuration ===

  # Go environment
  environment.variables = {
    GOPATH = "$HOME/go";
    GO111MODULE = "on";
  };

  # Python environment
  environment.variables = {
    PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages";
  };

  # Node.js environment
  environment.variables = {
    NODE_PATH = "$HOME/.npm-global/lib/node_modules";
  };

  # === Editor Configuration ===
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    configure = {
      customRC = ''
        " Basic QRY Neovim Configuration
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
        syntax on

        " QRY-specific settings
        set textwidth=80
        set colorcolumn=80

        " Auto-format on save for Go
        autocmd BufWritePre *.go lua vim.lsp.buf.format()
      '';
    };
  };

  # === Shell Configuration ===
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      # Modern CLI replacements
      ls = "exa";
      ll = "exa -l";
      la = "exa -la";
      tree = "exa --tree";
      cat = "bat";
      grep = "rg";
      find = "fd";

      # Git shortcuts
      g = "git";
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";

      # Docker shortcuts
      d = "docker";
      dc = "docker-compose";

      # System shortcuts
      top = "btop";
      du = "dust";
      df = "duf";
      ps = "procs";

      # QRY tools (once implemented)
      u = "uroboro";
      w = "wherewasi";
      d = "doggowoof";

      # Nix shortcuts
      nrs = "sudo nixos-rebuild switch";
      nrt = "sudo nixos-rebuild test";
      nrb = "sudo nixos-rebuild boot";

      # Development shortcuts
      serve = "python3 -m http.server";
      myip = "curl -s ifconfig.me";

      # QRY methodology shortcuts
      query = "echo 'What problem are we solving?'";
      refine = "echo 'How can we improve this?'";
      yield = "echo 'What did we learn?'";
    };
  };

  # === Development Services ===
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_15;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all ::1/128 trust
    '';
  };

  services.redis.servers."" = {
    enable = true;
    port = 6379;
  };

  # === Development Environment Setup ===
  environment.interactiveShellInit = ''
    # QRY Development Environment
    export QRY_DEV_PATH="$HOME/projects/qry"
    export QRY_TOOLS_PATH="$QRY_DEV_PATH/tools"
    export QRY_CONFIG_PATH="$HOME/.config/qry"
    export QRY_DATA_PATH="$HOME/.local/share/qry"

    # Create QRY directories if they don't exist
    mkdir -p "$QRY_CONFIG_PATH"
    mkdir -p "$QRY_DATA_PATH"

    # Add QRY tools to PATH when built
    export PATH="$QRY_TOOLS_PATH/bin:$PATH"

    # Development aliases
    alias qry-build="cd $QRY_DEV_PATH && make build"
    alias qry-test="cd $QRY_DEV_PATH && make test"
    alias qry-clean="cd $QRY_DEV_PATH && make clean"

    # Starship prompt
    eval "$(starship init zsh)"

    # Zoxide (better cd)
    eval "$(zoxide init zsh)"
  '';

  # === Git Configuration ===
  programs.git = {
    enable = true;
    config = {
      init.defaultBranch = "main";
      core.editor = "nvim";
      pull.rebase = true;
      push.autoSetupRemote = true;

      # QRY-specific git configuration
      user = {
        name = "QRY";
        email = "qry@example.com";  # Update with your email
      };

      # Aliases for QRY workflow
      alias = {
        co = "checkout";
        br = "branch";
        ci = "commit";
        st = "status";
        unstage = "reset HEAD --";
        last = "log -1 HEAD";
        visual = "!gitk";

        # QRY methodology aliases
        query = "!git log --oneline -10";
        refine = "!git add -A && git commit -m 'refine: systematic improvements'";
        yield = "!git log --oneline --since='1 week ago'";
      };
    };
  };

  # === Development Fonts ===
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "JetBrainsMono" "SourceCodePro" ]; })
  ];

  # === QRY Philosophy Integration ===
  # This module embodies:
  # - Local-first: All tools work offline
  # - Systematic: Consistent tool choices and configurations
  # - Anti-fragile: Easy to experiment and rollback
  # - Junkyard engineering: Tools that can be modified and understood
}
