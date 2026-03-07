#!/usr/bin/env bash
# ani-stream installer — Linux, macOS, Android/Termux

set -euo pipefail

REPO_URL="https://raw.githubusercontent.com/aliabdoxd27-source/ani-stream/main/ani-stream"
INSTALL_DIR=""
SCRIPT_NAME="ani-stream"

# Colors
RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[1;33m'
BLUE='\033[0;34m' CYAN='\033[0;36m' BOLD='\033[1m' RESET='\033[0m'

info()    { printf "${CYAN}[INFO]${RESET} %s\n" "$*"; }
success() { printf "${GREEN}[OK]${RESET}   %s\n" "$*"; }
warn()    { printf "${YELLOW}[WARN]${RESET} %s\n" "$*"; }
error()   { printf "${RED}[ERR]${RESET}  %s\n" "$*"; }
die()     { error "$*"; exit 1; }

detect_platform() {
    if [[ -n "${TERMUX_VERSION:-}" ]] || [[ -d "/data/data/com.termux" ]]; then
        printf "android"
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        printf "macos"
    elif [[ "$OSTYPE" == "linux"* ]]; then
        printf "linux"
    else
        printf "unknown"
    fi
}

install_system_deps() {
    local platform="$1"
    printf "\n${BOLD}${BLUE}Installing system dependencies...${RESET}\n"

    case "$platform" in
        android)
            info "Detected Termux/Android"
            info "Installing packages..."
            pkg update -y 2>/dev/null || true
            pkg install -y curl fzf python mpv 2>/dev/null || \
                warn "Some packages may have failed — install manually: pkg install curl fzf python mpv"
            info "Installing yt-dlp..."
            pip install -q yt-dlp 2>/dev/null || \
                pip3 install -q yt-dlp 2>/dev/null || \
                warn "Could not install yt-dlp via pip — try: pip install yt-dlp"
            ;;
        macos)
            info "Detected macOS"
            if command -v brew &>/dev/null; then
                info "Using Homebrew..."
                brew install curl fzf mpv 2>/dev/null || true
                brew install yt-dlp 2>/dev/null || pip3 install yt-dlp || true
            else
                warn "Homebrew not found. Install from https://brew.sh then run:"
                warn "  brew install curl fzf mpv yt-dlp"
            fi
            ;;
        linux)
            info "Detected Linux"
            if command -v apt-get &>/dev/null; then
                sudo apt-get install -y curl fzf mpv python3 python3-pip 2>/dev/null || true
            elif command -v pacman &>/dev/null; then
                # Arch: yt-dlp is in official repos
                sudo pacman -S --noconfirm --needed curl fzf mpv python python-pip yt-dlp 2>/dev/null || true
            elif command -v dnf &>/dev/null; then
                sudo dnf install -y curl fzf mpv python3 python3-pip yt-dlp 2>/dev/null || true
            else
                warn "Unknown package manager. Install manually: curl fzf mpv python3"
            fi
            
            if ! command -v yt-dlp &>/dev/null; then
                info "Attempting yt-dlp install via pip..."
                pip3 install yt-dlp 2>/dev/null || \
                pip3 install yt-dlp --break-system-packages 2>/dev/null || \
                warn "Could not install yt-dlp. Try: sudo apt install yt-dlp OR pip install yt-dlp"
            fi
            ;;
    esac
}

install_script() {
    local platform="$1"
    local script_path

    # Determine install dir
    if [[ "$platform" == "android" ]]; then
        INSTALL_DIR="/data/data/com.termux/files/usr/bin"
    elif [[ -d "$HOME/.local/bin" ]]; then
        INSTALL_DIR="$HOME/.local/bin"
    elif [[ -d "/usr/local/bin" ]] && [[ -w "/usr/local/bin" ]]; then
        INSTALL_DIR="/usr/local/bin"
    else
        INSTALL_DIR="$HOME/.local/bin"
        mkdir -p "$INSTALL_DIR"
    fi

    script_path="${INSTALL_DIR}/${SCRIPT_NAME}"

    # Copy or download the script
    if [[ -f "$(dirname "$0")/ani-stream" ]]; then
        info "Copying from local directory..."
        cp "$(dirname "$0")/ani-stream" "$script_path"
    elif [[ -f "./ani-stream" ]]; then
        cp "./ani-stream" "$script_path"
    else
        info "Downloading from repository..."
        curl -L "$REPO_URL" -o "$script_path" 2>/dev/null || \
            die "Download failed. Check your connection."
    fi

    chmod +x "$script_path"
    success "Installed to: $script_path"

    # Check PATH
    if [[ ! ":$PATH:" == *":$INSTALL_DIR:"* ]]; then
        warn "$INSTALL_DIR is not in your PATH"
        warn "Add this to your ~/.bashrc or ~/.zshrc:"
        warn "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    fi
}

print_android_mpv_guide() {
    printf "\n${BOLD}${BLUE}MPV Android App Setup (Optional):${RESET}\n"
    printf "\n  If you want to watch anime in the full MPV Android app\n"
    printf "  (instead of inside Termux), install it from:\n"
    printf "\n  • F-Droid: https://f-droid.org (search 'mpv-android')\n"
    printf "  • GitHub:  https://github.com/mpv-android/mpv-android/releases\n"
    printf "\n  Then in ani-stream Settings, choose:\n"
    printf "  '6. Use MPV Android app (intent)'\n"
    printf "\n  This will open each episode directly in the MPV Android app,\n"
    printf "  giving you full hardware decoding, gestures, and pip mode.\n"
}

main() {
    printf "\n${BOLD}${CYAN}ani-stream Installer${RESET}\n"
    printf "================================\n"

    local platform
    platform=$(detect_platform)
    info "Platform: $platform"

    # Ask about deps
    printf "\n"
    printf "${YELLOW}Install system dependencies (mpv, fzf, yt-dlp)?${RESET} [Y/n]: "
    read -r install_deps_choice </dev/tty
    if [[ "${install_deps_choice,,}" != "n" ]]; then
        install_system_deps "$platform"
    fi

    printf "\n"
    info "Installing ani-stream script..."
    install_script "$platform"

    printf "\n"
    success "Installation complete!\n"
    printf "${BOLD}Usage:${RESET}\n"
    printf "  ${CYAN}ani-stream${RESET}              # Interactive mode\n"
    printf "  ${CYAN}ani-stream \"One Piece\"${RESET}  # Search directly\n"
    printf "  ${CYAN}ani-stream --help${RESET}       # Show all options\n"

    [[ "$platform" == "android" ]] && print_android_mpv_guide

    printf "\n"
}

main "$@"
