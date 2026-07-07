#!/bin/bash
#
# IVII-Dots installer
# update -> check noctalia -> install deps -> make dirs -> clone -> copy -> starship init -> finish
#
set -euo pipefail

# ---- Config -----------------------------------------------------------

REPO_URL="https://github.com/kaizokuv/IVII-Dots.git"
CLONE_DIR="$HOME/IVII-Dots"
CONFIG_DIR="$HOME/.config"

# Standard repo packages (installed via AUR helper)
DEPS=(
    hyprland
    noctalia-git
    mpd
    mpd-dinit
    rmpc
    kitty
    neovim
    fastfetch
    yazi
    fish
    cava
    btop
    starship
    power-profiles-daemon
    power-profiles-daemon-dinit
    mpvpaper
    bluez
    bluez-dinit
    bluez-utils
    brave-bin
    eza
    kotofetch
    matugen-git
    networkmanager
    networkmanager-dinit
    pipewire-alsa
    pipewire-dinit
    pipewire-pulse
    pipewire-pulse-dinit
    wireplumber-dinit
    zoxide
)

RISHOT_INSTALL_URL="https://raw.githubusercontent.com/Gakuseei/rishot/main/install.sh"

# ---- Helpers ------------------------------------------------------------

log() {
    echo "[$(date '+%H:%M:%S')] $1"
}

die() {
    echo "ERROR: $1" >&2
    exit 1
}

AUR_HELPER=""

detect_aur_helper() {
    if command -v paru &> /dev/null; then
        AUR_HELPER="paru"
    elif command -v yay &> /dev/null; then
        AUR_HELPER="yay"
    else
        die "No AUR helper found (paru or yay required). Install one first."
    fi
    log "Using AUR helper: $AUR_HELPER"
}

# ---- Steps ----------------------------------------------------------------

update_system() {
    log "Updating system..."
    "$AUR_HELPER" -Syu --noconfirm
}

check_noctalia() {
    log "Checking for noctalia-git..."
    if "$AUR_HELPER" -Qi noctalia-git &> /dev/null; then
        log "noctalia-git already installed, skipping"
    else
        log "noctalia-git not found, will be installed with other deps"
    fi
}

install_rishot() {
    log "Checking for rishot..."
    if command -v rishot &> /dev/null; then
        log "rishot already installed, skipping"
        return
    fi
    log "Installing rishot..."
    curl -fsSL "$RISHOT_INSTALL_URL" | sh || die "rishot install failed"
}

install_deps() {
    log "Installing dependencies via $AUR_HELPER..."
    local failed=()

    for pkg in "${DEPS[@]}"; do
        if "$AUR_HELPER" -S --needed --noconfirm "$pkg"; then
            log "  [OK] $pkg"
        else
            log "  [FAIL] $pkg"
            failed+=("$pkg")
        fi
    done

    install_rishot

    if [[ ${#failed[@]} -gt 0 ]]; then
        die "Failed to install: ${failed[*]}"
    fi
}

make_directories() {
    log "Creating required directories..."
    mkdir -p "$CONFIG_DIR"
    mkdir -p "$CONFIG_DIR/fish"
    mkdir -p "$HOME/.local/share/noctalia/plugins"
}

clone_repo() {
    log "Cloning dotfiles repo..."
    if [[ -d "$CLONE_DIR" ]]; then
        log "  Repo already exists at $CLONE_DIR, pulling latest instead"
        git -C "$CLONE_DIR" pull
    else
        git clone "$REPO_URL" "$CLONE_DIR" || die "Clone failed"
    fi
}

copy_files() {
    log "Copying config files..."

    cp -r "$CLONE_DIR/hypr/" "$CONFIG_DIR/"
    cp -r "$CLONE_DIR/noctalia/" "$CONFIG_DIR/"
    cp -r "$CLONE_DIR/noctalia/plugins" "$HOME/.local/share/noctalia/plugins/"
    cp -r "$CLONE_DIR/fastfetch/" "$CONFIG_DIR/"
    cp -r "$CLONE_DIR/kitty/" "$CONFIG_DIR/"
    cp -r "$CLONE_DIR/nvim/" "$CONFIG_DIR/"
    cp -r "$CLONE_DIR/btop/" "$CONFIG_DIR/"
    cp -r "$CLONE_DIR/cava/" "$CONFIG_DIR/"
    cp "$CLONE_DIR/starship.toml" "$CONFIG_DIR/"
    cp "$CLONE_DIR/config.fish" "$CONFIG_DIR/fish/"
}

setup_starship() {
    log "Configuring starship for detected shell..."
    local shell_name
    shell_name=$(basename "$SHELL")

    case "$shell_name" in
        fish)
            local rc="$CONFIG_DIR/fish/config.fish"
            if ! grep -q "starship init fish" "$rc" 2>/dev/null; then
                echo 'starship init fish | source' >> "$rc"
                log "  Added starship init to $rc"
            else
                log "  starship already configured in $rc"
            fi
            ;;
        bash)
            local rc="$HOME/.bashrc"
            if ! grep -q "starship init bash" "$rc" 2>/dev/null; then
                echo 'eval "$(starship init bash)"' >> "$rc"
                log "  Added starship init to $rc"
            else
                log "  starship already configured in $rc"
            fi
            ;;
        zsh)
            local rc="$HOME/.zshrc"
            if ! grep -q "starship init zsh" "$rc" 2>/dev/null; then
                echo 'eval "$(starship init zsh)"' >> "$rc"
                log "  Added starship init to $rc"
            else
                log "  starship already configured in $rc"
            fi
            ;;
        *)
            log "  Unrecognized shell ($shell_name) — add starship init manually"
            ;;
    esac
}

finish() {
    log "Done. Dotfiles installed to $CONFIG_DIR"
    log "Restart your shell (or 'exec \$SHELL') and log out/in to Hyprland for everything to take effect."
}

# ---- Main -----------------------------------------------------------------

main() {
    detect_aur_helper
    update_system
    check_noctalia
    install_deps
    make_directories
    clone_repo
    copy_files
    setup_starship
    finish
}

main "$@"
