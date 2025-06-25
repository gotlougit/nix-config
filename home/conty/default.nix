{ pkgs, lib, config, ... }:

let
  cfg = config.programs.conty;

  # Helper script to download and set up a conty image
  setupScript = pkgs.writeShellScript "conty-setup" ''
    set -e

    CONTY_DIR="$HOME/.local/share/conty"
    CONTY_IMAGE="$CONTY_DIR/conty.sh"

    echo "Conty Setup Script"
    echo "=================="
    echo

    # Create directory
    mkdir -p "$CONTY_DIR"

    if [ -f "$CONTY_IMAGE" ]; then
      echo "Conty image already exists at: $CONTY_IMAGE"
      echo "Size: $(du -h "$CONTY_IMAGE" | cut -f1)"
      echo
      echo "To re-download, remove the existing image first:"
      echo "  rm '$CONTY_IMAGE'"
      exit 0
    fi

    echo "Downloading latest Conty image..."
    echo "This may take a while as the image is quite large (~2GB)"
    echo

    if command -v curl >/dev/null 2>&1; then
      curl -L --progress-bar \
        "https://github.com/Kron4ek/Conty/releases/latest/download/conty.sh" \
        -o "$CONTY_IMAGE"
    elif command -v wget >/dev/null 2>&1; then
      wget --progress=bar \
        "https://github.com/Kron4ek/Conty/releases/latest/download/conty.sh" \
        -O "$CONTY_IMAGE"
    else
      echo "Error: Neither curl nor wget found. Please install one of them."
      exit 1
    fi

    chmod +x "$CONTY_IMAGE"

    echo
    echo "Setup complete! Conty image installed at: $CONTY_IMAGE"
    echo "Size: $(du -h "$CONTY_IMAGE" | cut -f1)"
    echo
    echo "Usage examples:"
    echo "  conty firefox           # Run Firefox in container"
    echo "  conty steam             # Run Steam in container"
    echo "  conty wine app.exe      # Run Windows app via Wine"
    echo "  conty --help            # Show all options"
  '';

  # Helper script for common gaming tasks
  gamingScript = pkgs.writeShellScript "conty-gaming" ''
    set -e

    echo "Conty Gaming Helper"
    echo "==================="
    echo
    echo "Available gaming commands:"
    echo "  1) steam     - Launch Steam"
    echo "  2) lutris    - Launch Lutris"
    echo "  3) wine      - Launch Wine configuration"
    echo "  4) custom    - Enter custom command"
    echo "  q) quit"
    echo

    read -p "Choose an option: " choice

    case "$choice" in
      1|steam)
        echo "Launching Steam in Conty container..."
        exec conty steam
        ;;
      2|lutris)
        echo "Launching Lutris in Conty container..."
        exec conty lutris
        ;;
      3|wine)
        echo "Launching Wine configuration in Conty container..."
        exec conty winecfg
        ;;
      4|custom)
        read -p "Enter command to run in Conty: " cmd
        if [ -n "$cmd" ]; then
          echo "Running: conty $cmd"
          exec conty $cmd
        fi
        ;;
      q|quit)
        exit 0
        ;;
      *)
        echo "Invalid option"
        exit 1
        ;;
    esac
  '';

in {
  options.programs.conty = {
    enable = lib.mkEnableOption "Conty container runtime";

    autoSetup = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Automatically download Conty image on first activation";
    };

    aliases = lib.mkOption {
      type = lib.types.attrsOf lib.types.str;
      default = {
        conty-firefox = "conty firefox";
        conty-steam = "conty steam";
        conty-lutris = "conty lutris";
        conty-wine = "conty wine";
      };
      description = "Shell aliases for common Conty commands";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      conty  # The main conty package from overlay
      (pkgs.writeShellScriptBin "conty-setup" ''exec ${setupScript} "$@"'')
      (pkgs.writeShellScriptBin "conty-gaming" ''exec ${gamingScript} "$@"'')
    ];

    # Create necessary directories
    home.file.".local/share/conty/.keep".text = "";

    # Shell aliases
    home.shellAliases = cfg.aliases;

    # Environment variables
    home.sessionVariables = {
      CONTY_DIR = "$HOME/.local/share/conty";
    };

    # Auto-setup activation script
    home.activation = lib.mkIf cfg.autoSetup {
      contySetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
        CONTY_IMAGE="$HOME/.local/share/conty/conty.sh"
        if [ ! -f "$CONTY_IMAGE" ]; then
          echo "Auto-setting up Conty..."
          ${setupScript}
        fi
      '';
    };
  };
}
