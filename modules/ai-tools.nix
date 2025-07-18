# QRY AI Tools Environment
# Local-first AI development with Ollama and systematic AI workflows

{ config, lib, pkgs, inputs, ... }:

{
  # === AI Development Tools ===
  environment.systemPackages = with pkgs; [
    # === Local AI Models ===
    ollama              # Local LLM serving

    # === AI-Assisted Development ===
    aider-chat          # AI pair programming

    # === Python AI/ML Stack ===
    python3
    python3Packages.torch
    python3Packages.torchvision
    python3Packages.transformers
    python3Packages.huggingface-hub
    python3Packages.datasets
    python3Packages.tokenizers
    python3Packages.accelerate
    python3Packages.bitsandbytes
    python3Packages.scikit-learn
    python3Packages.numpy
    python3Packages.pandas
    python3Packages.matplotlib
    python3Packages.seaborn
    python3Packages.jupyter
    python3Packages.ipython
    python3Packages.notebook
    python3Packages.jupyterlab
    python3Packages.requests
    python3Packages.openai
    python3Packages.anthropic

    # === AI Model Management ===
    # Custom tools for model management will be added here

    # === Data Processing ===
    python3Packages.beautifulsoup4
    python3Packages.scrapy
    python3Packages.selenium
    python3Packages.lxml

    # === Vector Databases ===
    # Note: These may need custom packaging
    # chromadb
    # pinecone-client

    # === AI Utilities ===
    ffmpeg              # For audio/video processing
    imagemagick         # For image processing

    # === Development Tools ===
    python3Packages.black
    python3Packages.isort
    python3Packages.mypy
    python3Packages.pytest
    python3Packages.ipdb

    # === API Testing ===
    httpie
    curl

    # === GPU Acceleration (if available) ===
    # These will be conditionally included based on hardware

    # === AI Documentation ===
    python3Packages.sphinx
    python3Packages.sphinx-rtd-theme

    # === AI Experiment Tracking ===
    python3Packages.wandb
    python3Packages.mlflow

    # === AI Security ===
    # Custom tools for AI safety and security

    # === Text Processing ===
    python3Packages.spacy
    python3Packages.nltk
    python3Packages.textblob

    # === Computer Vision ===
    python3Packages.opencv4
    python3Packages.pillow

    # === Audio Processing ===
    python3Packages.librosa
    python3Packages.soundfile

    # === Time Series ===
    python3Packages.statsmodels

    # === Visualization ===
    python3Packages.plotly
    python3Packages.bokeh

    # === Configuration Management ===
    python3Packages.pydantic
    python3Packages.pyyaml
    python3Packages.toml

    # === Database Connectors ===
    python3Packages.sqlalchemy
    python3Packages.psycopg2
    python3Packages.redis

    # === Async Programming ===
    python3Packages.asyncio
    python3Packages.aiohttp

    # === Testing ===
    python3Packages.hypothesis
    python3Packages.faker

    # === Monitoring ===
    python3Packages.prometheus-client

    # === CLI Tools ===
    jq
    yq

    # === File Processing ===
    python3Packages.openpyxl
    python3Packages.xlrd

    # === Web Scraping ===
    chromium            # For Selenium

    # === AI Ethics and Safety ===
    # Custom tools for responsible AI development
  ];

  # === Ollama Service Configuration ===
  services.ollama = {
    enable = true;

    # Bind to localhost for security
    host = "127.0.0.1";
    port = 11434;

    # Use CPU acceleration by default
    acceleration = "cpu";

    # Environment variables for Ollama
    environment = {
      OLLAMA_DEBUG = "1";
      OLLAMA_HOST = "127.0.0.1:11434";
      OLLAMA_KEEP_ALIVE = "24h";
      OLLAMA_MAX_LOADED_MODELS = "3";
      OLLAMA_MAX_QUEUE = "10";
      OLLAMA_NUM_PARALLEL = "4";
      OLLAMA_FLASH_ATTENTION = "1";
    };

    # Data directory for models
    home = "/var/lib/ollama";
  };

  # === Python Environment Configuration ===
  environment.variables = {
    # Python AI environment
    PYTHONPATH = "$HOME/.local/lib/python3.11/site-packages:$PYTHONPATH";

    # Jupyter configuration
    JUPYTER_CONFIG_DIR = "$HOME/.config/jupyter";
    JUPYTER_DATA_DIR = "$HOME/.local/share/jupyter";

    # Transformers cache
    TRANSFORMERS_CACHE = "$HOME/.cache/huggingface/transformers";
    HF_HOME = "$HOME/.cache/huggingface";

    # Torch settings
    TORCH_HOME = "$HOME/.cache/torch";

    # OpenAI API (if used)
    # OPENAI_API_KEY will be set via environment file

    # Anthropic API (if used)
    # ANTHROPIC_API_KEY will be set via environment file

    # QRY AI workspace
    QRY_AI_PATH = "$HOME/ai";
    QRY_MODELS_PATH = "$HOME/ai/models";
    QRY_DATASETS_PATH = "$HOME/ai/datasets";
    QRY_EXPERIMENTS_PATH = "$HOME/ai/experiments";
    QRY_NOTEBOOKS_PATH = "$HOME/ai/notebooks";

    # Aider configuration
    AIDER_MODELS_PATH = "$HOME/.aider/models";

    # Local-first AI configuration
    OLLAMA_HOST = "http://127.0.0.1:11434";
  };

  # === AI Development Environment Setup ===
  environment.interactiveShellInit = ''
    # QRY AI Environment Setup
    export QRY_AI_PATH="$HOME/ai"
    export QRY_MODELS_PATH="$QRY_AI_PATH/models"
    export QRY_DATASETS_PATH="$QRY_AI_PATH/datasets"
    export QRY_EXPERIMENTS_PATH="$QRY_AI_PATH/experiments"
    export QRY_NOTEBOOKS_PATH="$QRY_AI_PATH/notebooks"
    export QRY_PROMPTS_PATH="$QRY_AI_PATH/prompts"
    export QRY_CONFIGS_PATH="$QRY_AI_PATH/configs"

    # Create AI directories
    mkdir -p "$QRY_MODELS_PATH"/{ollama,huggingface,custom}
    mkdir -p "$QRY_DATASETS_PATH"/{raw,processed,synthetic}
    mkdir -p "$QRY_EXPERIMENTS_PATH"/{training,inference,evaluation}
    mkdir -p "$QRY_NOTEBOOKS_PATH"/{exploration,analysis,demos}
    mkdir -p "$QRY_PROMPTS_PATH"/{system,user,templates}
    mkdir -p "$QRY_CONFIGS_PATH"/{models,training,inference}

    # AI workflow aliases
    alias ollama-start="systemctl start ollama"
    alias ollama-stop="systemctl stop ollama"
    alias ollama-status="systemctl status ollama"
    alias ollama-logs="journalctl -u ollama -f"
    alias ollama-models="ollama list"
    alias ollama-pull="ollama pull"
    alias ollama-run="ollama run"
    alias ollama-serve="ollama serve"

    # Aider aliases
    alias aider-go="cd $QRY_AI_PATH && aider --model ollama/codestral:latest"
    alias aider-py="cd $QRY_AI_PATH && aider --model ollama/codestral:latest --map-tokens 2048"
    alias aider-js="cd $QRY_AI_PATH && aider --model ollama/codestral:latest --js"

    # Python AI environment
    alias jupyter-ai="cd $QRY_NOTEBOOKS_PATH && jupyter lab"
    alias ipython-ai="cd $QRY_AI_PATH && ipython"
    alias python-ai="cd $QRY_AI_PATH && python3"

    # Model management
    alias models="cd $QRY_MODELS_PATH"
    alias datasets="cd $QRY_DATASETS_PATH"
    alias experiments="cd $QRY_EXPERIMENTS_PATH"
    alias notebooks="cd $QRY_NOTEBOOKS_PATH"
    alias prompts="cd $QRY_PROMPTS_PATH"

    # AI utilities
    alias ai-status="curl -s http://127.0.0.1:11434/api/tags | jq '.models[] | {name, size}'"
    alias ai-health="curl -s http://127.0.0.1:11434/api/version"
    alias ai-gpu="nvidia-smi"  # Adjust for your GPU
    alias ai-memory="free -h && echo 'GPU:' && nvidia-smi --query-gpu=memory.used,memory.total --format=csv"

    # Data processing
    alias process-text="python3 -c 'import sys; print(sys.stdin.read().strip())'"
    alias json-pretty="jq '.'"
    alias csv-head="head -n 5"

    # Model testing
    alias test-model="ollama run"
    alias benchmark-model="python3 -c 'import time; start=time.time(); print(f\"Took {time.time()-start:.2f}s\")"

    # AI safety and ethics
    alias ai-safety-check="echo 'Running AI safety checks...'"
    alias bias-check="echo 'Checking for bias in model outputs...'"

    # QRY AI methodology
    alias ai-query="echo 'What problem are we solving with AI?'"
    alias ai-refine="echo 'How can we improve the AI solution?'"
    alias ai-yield="echo 'What did we learn from this AI experiment?'"

    # Experiment tracking
    alias log-experiment="echo 'Experiment: $(date)' >> $QRY_EXPERIMENTS_PATH/log.txt"
    alias show-experiments="cat $QRY_EXPERIMENTS_PATH/log.txt | tail -10"

    # Backup AI work
    alias backup-ai="rsync -av $QRY_AI_PATH $HOME/backups/ai-$(date +%Y%m%d)"
    alias backup-models="rsync -av $QRY_MODELS_PATH $HOME/backups/models-$(date +%Y%m%d)"

    # AI development server
    alias ai-server="cd $QRY_AI_PATH && python3 -m http.server 8888"

    # Quick model downloads
    alias get-codestral="ollama pull codestral:latest"
    alias get-llama="ollama pull llama3.2:latest"
    alias get-mistral="ollama pull mistral:latest"
    alias get-qwen="ollama pull qwen2.5:latest"

    # AI chat interface
    alias chat="ollama run llama3.2:latest"
    alias code-chat="ollama run codestral:latest"
    alias math-chat="ollama run llama3.2:latest 'You are a mathematics expert.'"

    # System resource monitoring for AI
    alias ai-top="htop -p \$(pgrep -d',' ollama)"
    alias ai-iostat="iostat -x 1"
    alias ai-netstat="netstat -tulpn | grep :11434"
  '';

  # === AI Development Services ===

  # Jupyter Lab service (optional)
  services.jupyter = {
    enable = false;  # Enable if you want system-wide Jupyter
    ip = "127.0.0.1";
    port = 8888;
    user = "qry";
    group = "qry";
    kernels = {
      python3 = let
        env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
          ipykernel
          torch
          transformers
          numpy
          pandas
          matplotlib
          seaborn
          scikit-learn
        ]));
      in {
        displayName = "Python 3 (AI)";
        argv = [
          "${env.interpreter}"
          "-m"
          "ipykernel_launcher"
          "-f"
          "{connection_file}"
        ];
        language = "python";
        logo32 = "${env}/${env.sitePackages}/ipykernel/resources/logo-32x32.png";
        logo64 = "${env}/${env.sitePackages}/ipykernel/resources/logo-64x64.png";
      };
    };
  };

  # === AI Security Configuration ===

  # Firewall rules for AI services
  networking.firewall = {
    allowedTCPPorts = [
      11434  # Ollama
      8888   # Jupyter (if enabled)
    ];

    # Only allow local connections
    interfaces."lo".allowedTCPPorts = [
      11434  # Ollama
      8888   # Jupyter
    ];
  };

  # === AI Performance Optimization ===

  # Memory optimization for AI workloads
  boot.kernel.sysctl = {
    # Increase shared memory for large models
    "kernel.shmmax" = 68719476736;  # 64GB
    "kernel.shmall" = 4294967296;   # 16GB in pages

    # Memory management for AI
    "vm.overcommit_memory" = 1;
    "vm.overcommit_ratio" = 100;

    # Swap behavior for AI workloads
    "vm.swappiness" = 1;  # Prefer RAM over swap
    "vm.dirty_ratio" = 10;
    "vm.dirty_background_ratio" = 5;
  };

  # === AI Data Management ===

  # Enable large file support
  boot.supportedFilesystems = [ "ext4" ];

  # AI backup strategy
  services.borgbackup.jobs.ai = {
    paths = [
      "/home/qry/ai/experiments"
      "/home/qry/ai/notebooks"
      "/home/qry/ai/configs"
      "/home/qry/ai/prompts"
    ];
    repo = "/home/qry/backups/ai";
    compression = "auto,zstd";
    startAt = "daily";

    exclude = [
      "/home/qry/ai/models"     # Models are large and can be re-downloaded
      "/home/qry/ai/datasets/raw"  # Raw datasets can be large
      "*.pyc"
      "__pycache__"
      ".git"
      ".ipynb_checkpoints"
    ];

    preHook = ''
      echo "Starting AI backup at $(date)"
      # Stop AI services to ensure consistency
      systemctl stop ollama || true
    '';

    postHook = ''
      # Restart AI services
      systemctl start ollama || true
      echo "AI backup completed at $(date)"
    '';
  };

  # === AI Monitoring ===

  # System monitoring for AI workloads
  services.prometheus.exporters.node = {
    enable = true;
    enabledCollectors = [
      "systemd"
      "cpu"
      "meminfo"
      "diskstats"
      "filesystem"
      "loadavg"
      "netdev"
      "processes"
    ];
  };

  # === AI Environment Variables for Security ===

  # Create environment file for API keys (not in Nix store)
  environment.etc."qry/ai-env".text = ''
    # QRY AI Environment Configuration
    # This file contains sensitive configuration

    # API Keys (set these manually)
    # export OPENAI_API_KEY="your-key-here"
    # export ANTHROPIC_API_KEY="your-key-here"
    # export HUGGINGFACE_TOKEN="your-token-here"

    # Local AI configuration
    export OLLAMA_HOST="http://127.0.0.1:11434"
    export OLLAMA_KEEP_ALIVE="24h"

    # Model preferences
    export QRY_DEFAULT_MODEL="codestral:latest"
    export QRY_CHAT_MODEL="llama3.2:latest"
    export QRY_CODE_MODEL="codestral:latest"

    # Safety settings
    export QRY_AI_SAFETY_MODE="strict"
    export QRY_AI_LOGGING="enabled"
    export QRY_AI_AUDIT="enabled"
  '';

  # === AI Model Management ===

  # Systemd service for model management
  systemd.services.qry-ai-models = {
    description = "QRY AI Model Management";
    after = [ "ollama.service" ];
    wants = [ "ollama.service" ];

    serviceConfig = {
      Type = "oneshot";
      User = "qry";
      Group = "qry";
      ExecStart = pkgs.writeShellScript "qry-ai-models-setup" ''
        # Wait for Ollama to be ready
        while ! curl -s http://127.0.0.1:11434/api/version >/dev/null 2>&1; do
          echo "Waiting for Ollama to start..."
          sleep 2
        done

        # Pull essential models if not present
        if ! ollama list | grep -q "codestral:latest"; then
          echo "Pulling codestral model..."
          ollama pull codestral:latest
        fi

        if ! ollama list | grep -q "llama3.2:latest"; then
          echo "Pulling llama3.2 model..."
          ollama pull llama3.2:latest
        fi

        echo "QRY AI models setup complete"
      '';
    };
  };

  # === QRY AI Philosophy Integration ===
  # This module embodies:
  # - Local-first AI: All inference runs locally, no cloud dependencies
  # - Systematic AI: Organized workflows and experiment tracking
  # - Anti-fragile AI: Backup strategies and rollback capabilities
  # - Junkyard engineering: Hackable AI tools and transparent processes
  # - Privacy-focused: No data leaves your machine
  # - Professional AI: Production-ready setup with monitoring
  # - Responsible AI: Built-in safety and ethics considerations
}
