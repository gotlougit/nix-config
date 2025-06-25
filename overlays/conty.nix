final: prev: {
  conty = prev.callPackage ({ lib, stdenv, fetchFromGitHub, makeWrapper
    , writeShellScript, writeText, bubblewrap, fuse3, squashfsTools, squashfuse
    , coreutils, util-linux, curl, gnutar, gzip, bash, packages ? [
      # Default package list that would be used if building from scratch
      "base"
      "base-devel"
      "linux"
      "linux-firmware"
      "mesa"
      "lib32-mesa"
      "vulkan-icd-loader"
      "lib32-vulkan-icd-loader"
      "alsa-lib"
      "lib32-alsa-lib"
      "pipewire"
      "lib32-pipewire"
      "wine-staging"
      "steam"
      "lutris"
      "firefox"
      "git"
    ], compressionAlgorithm ? "zstd", compressionLevel ? 19 }:

    let
      # Create a custom settings file for reference
      customSettings = writeText "conty-settings.sh" ''
        # Custom Conty settings for NixOS build
        PACKAGES=(
          ${lib.concatMapStringsSep "\n  " (pkg: ''"${pkg}"'') packages}
        )

        SQUASHFS_COMPRESSOR="${compressionAlgorithm}"
        SQUASHFS_COMPRESSOR_ARGUMENTS=(-b 1M -comp "${compressionAlgorithm}" -Xcompression-level ${
          toString compressionLevel
        })

        USE_SYS_UTILS=1
      '';

      # Create a wrapper script that handles the Conty runtime
      contyWrapper = writeShellScript "conty" ''
        set -e

        # Conty NixOS Edition
        export USE_SYS_UTILS=1
        export PATH="${
          lib.makeBinPath [
            bubblewrap
            fuse3
            squashfsTools
            squashfuse
            coreutils
            util-linux
            curl
            gnutar
            gzip
          ]
        }:$PATH"

        # Check for required tools
        missing_tools=()
        for tool in bwrap squashfuse mksquashfs unsquashfs fusermount3; do
          if ! command -v "$tool" >/dev/null 2>&1; then
            missing_tools+=("$tool")
          fi
        done

        if [ ''${#missing_tools[@]} -gt 0 ]; then
          echo "Error: Missing required tools: ''${missing_tools[*]}"
          echo "This shouldn't happen in a NixOS environment."
          exit 1
        fi

        # Look for Conty image in several locations
        conty_image=""
        script_dir="$(dirname "$(readlink -f "$0")")"

        # Check for image in same directory as script
        if [ -f "$script_dir/conty.sh" ]; then
          conty_image="$script_dir/conty.sh"
        elif [ -f "$script_dir/../share/conty/conty.sh" ]; then
          conty_image="$script_dir/../share/conty/conty.sh"
        elif [ -f "$HOME/.local/share/conty/conty.sh" ]; then
          conty_image="$HOME/.local/share/conty/conty.sh"
        elif [ -f "/opt/conty/conty.sh" ]; then
          conty_image="/opt/conty/conty.sh"
        fi

        # If no image found, provide helpful instructions
        if [ -z "$conty_image" ] || [ ! -f "$conty_image" ]; then
          echo "Conty NixOS Edition - Container Runtime"
          echo "======================================"
          echo
          echo "No Conty container image found. To use Conty, you need to either:"
          echo
          echo "1. Download a pre-built Conty image:"
          echo "   mkdir -p ~/.local/share/conty"
          echo "   curl -L https://github.com/Kron4ek/Conty/releases/latest/download/conty.sh \\"
          echo "        -o ~/.local/share/conty/conty.sh"
          echo "   chmod +x ~/.local/share/conty/conty.sh"
          echo
          echo "2. Build your own Conty image using the provided scripts:"
          echo "   # Use the scripts in: @out@/share/conty/"
          echo "   # Note: This requires root access and network connectivity"
          echo
          echo "3. Specify a custom image location:"
          echo "   export CONTY_IMAGE=/path/to/your/conty.sh"
          echo
          echo "Available tools:"
          echo "- bubblewrap: $(command -v bwrap)"
          echo "- squashfuse: $(command -v squashfuse)"
          echo "- mksquashfs: $(command -v mksquashfs)"
          echo "- fusermount3: $(command -v fusermount3)"
          echo
          exit 1
        fi

        # Check if CONTY_IMAGE environment variable is set
        if [ -n "$CONTY_IMAGE" ] && [ -f "$CONTY_IMAGE" ]; then
          conty_image="$CONTY_IMAGE"
        fi

        echo "Using Conty image: $conty_image"

        # Execute the Conty image with all arguments
        exec "$conty_image" "$@"
      '';

      # Create a build script for users who want to build their own image
      buildScript = writeShellScript "conty-build" ''
        #!/usr/bin/env bash

        set -e

        echo "Conty Build Script (NixOS Edition)"
        echo "=================================="
        echo
        echo "This script will help you build a custom Conty container."
        echo "Note: This requires root access and network connectivity."
        echo

        if [ "$EUID" -ne 0 ]; then
          echo "Error: This script must be run as root to build the Arch Linux bootstrap."
          echo "Usage: sudo conty-build [output-directory]"
          exit 1
        fi

        OUTPUT_DIR="''${1:-$(pwd)}"
        CONTY_SOURCE="@out@/share/conty"

        if [ ! -d "$CONTY_SOURCE" ]; then
          echo "Error: Conty source not found at $CONTY_SOURCE"
          exit 1
        fi

        echo "Building Conty in: $OUTPUT_DIR"
        echo "Using source from: $CONTY_SOURCE"
        echo

        # Create temporary build directory
        BUILD_DIR=$(mktemp -d)
        trap "rm -rf $BUILD_DIR" EXIT

        # Copy source files
        cp -r "$CONTY_SOURCE"/* "$BUILD_DIR/"
        cd "$BUILD_DIR"

        # Make scripts executable
        chmod +x *.sh

        # Set up environment
        export PATH="${
          lib.makeBinPath [
            bubblewrap
            fuse3
            squashfsTools
            squashfuse
            coreutils
            util-linux
            curl
            gnutar
            gzip
          ]
        }:$PATH"

        echo "Step 1: Creating Arch Linux bootstrap..."
        if ! ./create-arch-bootstrap.sh; then
          echo "Error: Failed to create Arch Linux bootstrap"
          exit 1
        fi

        echo "Step 2: Creating Conty container..."
        if ! ./create-conty.sh; then
          echo "Error: Failed to create Conty container"
          exit 1
        fi

        # Copy result to output directory
        if [ -f conty.sh ]; then
          cp conty.sh "$OUTPUT_DIR/"
          echo
          echo "Success! Conty container created at: $OUTPUT_DIR/conty.sh"
          echo "You can now use it with: conty"
        else
          echo "Error: conty.sh was not created"
          exit 1
        fi
      '';

    in stdenv.mkDerivation {
      pname = "conty";
      version = "1.28";

      src = fetchFromGitHub {
        owner = "Kron4ek";
        repo = "Conty";
        rev = "1.28";
        sha256 = "0f4y2289ihvwryprxb91hr1jzm4hjpxqfv5cl8lq61h6798qmyhg";
      };

      nativeBuildInputs = [ makeWrapper ];
      buildInputs = [ bubblewrap fuse3 squashfsTools squashfuse ];

      buildPhase = ''
        # Nothing to build - we're just packaging the scripts
        echo "Packaging Conty runtime for NixOS..."
      '';

      installPhase = ''
        mkdir -p $out/bin $out/share/conty

        # Install the wrapper script
        cp ${contyWrapper} $out/bin/conty

        # Install the build script
        cp ${buildScript} $out/bin/conty-build

        # Install source files for users who want to build
        cp -r $src/* $out/share/conty/

        # Install custom settings
        cp ${customSettings} $out/share/conty/nixos-settings.sh

        # Create a README for users
        cat > $out/share/conty/README-NixOS.md << 'EOF'
        # Conty on NixOS

        This is a NixOS packaging of Conty that provides the runtime infrastructure.

        ## Quick Start

        1. Download a pre-built Conty image:
           ```bash
           mkdir -p ~/.local/share/conty
           curl -L https://github.com/Kron4ek/Conty/releases/latest/download/conty.sh \
                -o ~/.local/share/conty/conty.sh
           chmod +x ~/.local/share/conty/conty.sh
           ```

        2. Run applications:
           ```bash
           conty steam
           conty firefox
           conty wine some-game.exe
           ```

        ## Building Your Own Image

        If you want to build a custom Conty with your own package selection:

        ```bash
        # Edit the settings in nixos-settings.sh
        sudo conty-build /path/to/output/directory
        ```

        ## Environment Variables

        - `CONTY_IMAGE`: Path to custom Conty image file
        - Standard Conty variables (SANDBOX, DISABLE_NET, etc.) work as usual

        ## Files

        - `conty-start.sh`: Main runtime script
        - `create-arch-bootstrap.sh`: Bootstrap creation script
        - `create-conty.sh`: Container creation script
        - `nixos-settings.sh`: Custom settings for this build
        EOF

        # Make scripts executable
        chmod +x $out/bin/conty $out/bin/conty-build
        chmod +x $out/share/conty/*.sh

        # Substitute the @out@ placeholder in scripts
        substituteInPlace $out/bin/conty-build --replace "@out@" "$out"

        # Wrap the main script with proper PATH
        wrapProgram $out/bin/conty \
          --prefix PATH : ${
            lib.makeBinPath [
              bubblewrap
              fuse3
              squashfsTools
              squashfuse
              coreutils
              util-linux
              curl
              gnutar
              gzip
            ]
          }

        wrapProgram $out/bin/conty-build \
          --prefix PATH : ${
            lib.makeBinPath [
              bubblewrap
              fuse3
              squashfsTools
              squashfuse
              coreutils
              util-linux
              curl
              gnutar
              gzip
              bash
            ]
          }
      '';

      meta = with lib; {
        description =
          "Easy to use compressed unprivileged Linux container (NixOS runtime)";
        longDescription = ''
          Conty is a portable Linux container that works on most Linux distributions.

          This NixOS package provides the Conty runtime infrastructure and tools.
          To use it, you need to either download a pre-built Conty container image
          or build your own using the provided scripts.

          The original Conty contains a full Arch Linux environment with many
          pre-installed packages and can run applications including games with
          Vulkan and OpenGL support.
        '';
        homepage = "https://github.com/Kron4ek/Conty";
        license = licenses.mit;
        platforms = platforms.linux;
        maintainers = [ ];
        mainProgram = "conty";
      };
    }) { };
}
