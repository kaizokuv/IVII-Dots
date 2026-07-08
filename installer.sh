#!/bin/bash

set -euo pipefail

trap 'echo "ERROR: script failed at line $LINENO (exit code $?)" >&2' ERR

REPO_URL="https://github.com/kaizokuv/IVII-Dots.git"
CLONE_DIR="$HOME/IVII-Dots"
CONFIG_DIR="$HOME/.config"

DEPSSYSD=(
  hyprland
  noctalia-git
  mpd
  rmpc
  kitty
  neovim
  fastfetch
  yazi
  fish
  curl
  fd
  cava
  btop
  starship
  power-profiles-daemon
  mpvpaper
  bluez
  bluez-utils
  brave-bin
  eza
  kotofetch
  matugen-git
  networkmanager
  pipewire-alsa
  pipewire-pulse
  wireplumber
  zoxide
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  xorg-fonts-100dpi
  xorg-fonts-75dpi
  xorg-fonts-encodings
  xorg-mkfontscale
  pay-respects
  cloudflare-speed-cli
)

DEPSRUNIT=(
  hyprland
  noctalia-git
  mpd
  mpd-runit
  rmpc
  kitty
  neovim
  fastfetch
  yazi
  fish
  curl
  fd
  cava
  btop
  starship
  power-profiles-daemon
  power-profiles-daemon-runit
  mpvpaper
  bluez
  bluez-runit
  bluez-utils
  brave-bin
  eza
  kotofetch
  matugen-git
  networkmanager
  networkmanager-runit
  pipewire-alsa
  pipewire-runit
  pipewire-pulse
  pipewire-pulse-runit
  wireplumber
  wireplumber-runit
  zoxide
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  xorg-fonts-100dpi
  xorg-fonts-75dpi
  xorg-fonts-encodings
  xorg-mkfontscale
  pay-respects
  cloudflare-speed-cli
)

DEPSOPENRC=(
  hyprland
  noctalia-git
  mpd
  mpd-openrc
  rmpc
  kitty
  neovim
  fastfetch
  yazi
  fish
  curl
  fd
  cava
  btop
  starship
  power-profiles-daemon
  power-profiles-daemon-openrc
  mpvpaper
  bluez
  bluez-openrc
  bluez-utils
  brave-bin
  eza
  kotofetch
  matugen-git
  networkmanager
  networkmanager-openrc
  pipewire-alsa
  pipewire-dinit
  pipewire-pulse
  pipewire-pulse-openrc
  wireplumber
  wireplumber-openrc
  zoxide
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  xorg-fonts-100dpi
  xorg-fonts-75dpi
  xorg-fonts-encodings
  xorg-mkfontscale
  pay-respects
  cloudflare-speed-cli
)

DEPSDINIT=(
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
  curl
  fd
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
  wireplumber
  wireplumber-dinit
  zoxide
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  xorg-fonts-100dpi
  xorg-fonts-75dpi
  xorg-fonts-encodings
  xorg-mkfontscale
  pay-respects
  cloudflare-speed-cli
)

log() {
  echo "[$(date '+%H:%M:%S')] $1"
}

die() {
  echo "ERROR: $1" >&2
  exit 1
}

AUR_HELPER=""
FAILED_PACKAGES=()

detect_aur_helper() {
  if command -v yay &>/dev/null; then
    AUR_HELPER="yay"
  elif command -v paru &>/dev/null; then
    AUR_HELPER="paru"
  else
    die "No AUR helper found (paru or yay required). Install one first."
  fi
  log "Using AUR helper: $AUR_HELPER"
}

update_system() {
  log "Updating system..."
  "$AUR_HELPER" -Syu --noconfirm
}

check_noctalia() {
  log "Checking for noctalia-git..."
  if "$AUR_HELPER" -Qi noctalia-git &>/dev/null; then
    log "noctalia-git already installed, skipping"
  else
    log "noctalia-git not found, will be installed with other deps"
  fi
}

install_rishot() {
  log "Checking for rishot..."
  if command -v rishot &>/dev/null; then
    log "rishot already installed, skipping"
    return
  fi
  log "Installing rishot..."
  if curl -fsSL https://raw.githubusercontent.com/Gakuseei/rishot/main/install.sh | sh; then
    log "rishot installed successfully"
  else
    log "WARNING: rishot install failed (network issue or upstream script error) — continuing without it"
  fi
}

setup_path() {
  log "Ensuring ~/.local/bin is on PATH..."
  local shell_name
  shell_name=$(basename "$SHELL")

  case "$shell_name" in
  fish)
    fish -c 'fish_add_path ~/.local/bin' &>/dev/null
    log "  Added ~/.local/bin to fish PATH (universal var)"
    ;;
  bash)
    if ! grep -q '.local/bin' "$HOME/.bashrc" 2>/dev/null; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.bashrc"
      log "  Added ~/.local/bin to \$HOME/.bashrc"
    else
      log "  ~/.local/bin already on PATH in .bashrc"
    fi
    ;;
  zsh)
    if ! grep -q '.local/bin' "$HOME/.zshrc" 2>/dev/null; then
      echo 'export PATH="$HOME/.local/bin:$PATH"' >>"$HOME/.zshrc"
      log "  Added ~/.local/bin to \$HOME/.zshrc"
    else
      log "  ~/.local/bin already on PATH in .zshrc"
    fi
    ;;
  *)
    log "  Unrecognized shell ($shell_name) — add ~/.local/bin to PATH manually"
    ;;
  esac
}

set_default_shell() {
  log "Checking default shell..."

  local fish_path
  fish_path=$(command -v fish) || {
    log "  WARNING: fish not found on PATH, skipping shell change"
    return
  }

  if [[ "$SHELL" == "$fish_path" ]]; then
    log "  fish is already the default shell, skipping"
    return
  fi

  # chsh requires the shell to be registered in /etc/shells
  if ! grep -qx "$fish_path" /etc/shells 2>/dev/null; then
    log "  $fish_path not listed in /etc/shells, adding it (requires sudo)"
    echo "$fish_path" | sudo tee -a /etc/shells &>/dev/null
  fi

  log "  Changing default shell to fish — you will be prompted for your password"
  if chsh -s "$fish_path"; then
    log "  Default shell changed to fish. Takes effect on your next login."
  else
    log "  WARNING: chsh failed — you can change it manually later with: chsh -s $fish_path"
  fi
}

install_deps() {
  read -p " Choose init system: SystemD (1), OpenRC (2), Runit (3), Dinit (4): " choice

  local -n selected_deps
  case "$choice" in
  1) selected_deps=DEPSSYSD ;;
  2) selected_deps=DEPSOPENRC ;;
  3) selected_deps=DEPSRUNIT ;;
  4) selected_deps=DEPSDINIT ;;
  *) die "Invalid choice: $choice" ;;
  esac

  log "Installing dependencies via $AUR_HELPER..."
  local failed=()

  for pkg in "${selected_deps[@]}"; do
    if "$AUR_HELPER" -S --needed --noconfirm "$pkg"; then
      log "  [OK] $pkg"
    else
      log "  [FAIL] $pkg"
      failed+=("$pkg")
    fi
  done

  if [[ ${#failed[@]} -gt 0 ]]; then
    log "Retrying ${#failed[@]} failed package(s) after a cooldown: ${failed[*]}"
    sleep 30
    local still_failed=()
    for pkg in "${failed[@]}"; do
      if "$AUR_HELPER" -S --needed --noconfirm "$pkg"; then
        log "  [OK on retry] $pkg"
      else
        log "  [FAIL again] $pkg"
        still_failed+=("$pkg")
      fi
    done
    failed=("${still_failed[@]}")
  fi

  install_rishot

  if [[ ${#failed[@]} -gt 0 ]]; then
    FAILED_PACKAGES+=("${failed[@]}")
    log "WARNING: Failed to install: ${failed[*]} — continuing with the rest of the setup"
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

  local pairs=(
    "hypr:$CONFIG_DIR/"
    "noctalia:$CONFIG_DIR/"
    "noctalia/plugins:$HOME/.local/share/noctalia/plugins/"
    "fastfetch:$CONFIG_DIR/"
    "kitty:$CONFIG_DIR/"
    "nvim:$CONFIG_DIR/"
    "btop:$CONFIG_DIR/"
    "cava:$CONFIG_DIR/"
    "rmpc:$CONFIG_DIR/"
    "Wallpapers:$HOME/"
  )

  for pair in "${pairs[@]}"; do
    local src="${pair%%:*}"
    local dest="${pair##*:}"
    if [[ -e "$CLONE_DIR/$src" ]]; then
      cp -r "$CLONE_DIR/$src" "$dest"
      log "  [OK] $src -> $dest"
    else
      log "  [MISSING] $CLONE_DIR/$src not found, skipped"
    fi
  done

  if [[ -f "$CLONE_DIR/starship.toml" ]]; then
    cp "$CLONE_DIR/starship.toml" "$CONFIG_DIR/"
    log "  [OK] starship.toml"
  else
    log "  [MISSING] starship.toml not found, skipped"
  fi

  if [[ -f "$CLONE_DIR/config.fish" ]]; then
    cp "$CLONE_DIR/config.fish" "$CONFIG_DIR/fish/"
    log "  [OK] config.fish"
  else
    log "  [MISSING] config.fish not found, skipped"
  fi
}

finish() {
  log "Done. Dotfiles installed to $CONFIG_DIR"
  if [[ ${#FAILED_PACKAGES[@]} -gt 0 ]]; then
    log "NOTE: These packages failed to install and may need a manual retry:"
    log "  $AUR_HELPER -S ${FAILED_PACKAGES[*]}"
  fi
  log "Log out and back in for the default shell change and Hyprland config to take effect."
}

main() {
  detect_aur_helper
  update_system
  check_noctalia
  install_deps
  setup_path
  make_directories
  clone_repo
  copy_files
  set_default_shell
  finish
}

main "$@"
