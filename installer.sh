#!/bin/bash
set -euo pipefail

REPO_URL="https://github.com/kaizokuv/IVII-Dots.git"
CLONE_DIR="$HOME/IVII-Dots"
CONFIG_DIR="$HOME/.config"

DEPS=(
  hyprland
  mpd
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
)

# ---- Helpers ---------------------------------------------------------------

log() {
  echo "[$(date '+%H:%M:%S')] $1"
}

die() {
  echo "ERROR: $1" >&2
  exit 1
}

# ---- Steps -------------------------------------------------------------

update_system() {
  log "Updating system..."
  if command -v paru &>/dev/null; then
    paru -Syu --noconfirm
  else
    sudo pacman -Syu --noconfirm
  fi
}

check_noctalia() {
  log "Checking for noctalia..."
  if command -v noctalia &>/dev/null || yay -Qi noctalia &>/dev/null 2>&1; then
    log "noctalia already installed, skipping"
  else
    log "noctalia not found, installing..."
    yay -S --needed --noconfirm noctalia-git || die "Failed to install noctalia"
  fi
}

install_deps() {
  log "Installing dependencies..."
  local failed=()

  for pkg in "${DEPS[@]}"; do
    if paru -S --needed --noconfirm "$pkg"; then
      log "  [OK] $pkg"
    else
      log "  [FAIL] $pkg"
      failed+=("$pkg")
    fi
  done

  if [[ ${#failed[@]} -gt 0 ]]; then
    die "Failed to install: ${failed[*]}"
  fi
}

make_directories() {
  log "Creating required directories..."
  mkdir -p "$CONFIG_DIR"
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$HOME/.local/share/fonts"
  # add any other target dirs your configs expect
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
  # Manual copy (matches your repo layout — not symlinks/bare repo)
  # Adjust source subfolder names to match your actual repo structure
  cp -r "$CLONE_DIR/config/"* "$CONFIG_DIR/" || die "Copy failed"

  # Example: copy standalone scripts to ~/.local/bin
  if [[ -d "$CLONE_DIR/bin" ]]; then
    cp -r "$CLONE_DIR/bin/"* "$HOME/.local/bin/"
    chmod +x "$HOME/.local/bin/"*
  fi
}

finish() {
  log "Done. Dotfiles installed to $CONFIG_DIR"
  log "You may need to restart Hyprland or log out/in for everything to take effect."
}

# ---- Main --------------------------------------------------------------

main() {
  update_system
  check_noctalia
  install_deps
  make_directories
  clone_repo
  copy_files
  finish
}

main "$@"
