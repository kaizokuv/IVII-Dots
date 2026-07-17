#!/bin/bash

set -euo pipefail

trap 'echo "ERROR: script failed at line $LINENO (exit code $?)" >&2' ERR

REPO_URL="https://github.com/kaizokuv/IVII-Dots.git"
CLONE_DIR="$HOME/IVII-Dots"
CONFIG_DIR="$HOME/.config"

DEPSSYSD=(
  hyprland
  noctalia-git
  kitty
  neovim
  fastfetch
  fish
  curl
  fd
  starship
  power-profiles-daemon
  bluez
  bluez-utils
  eza
  git-lfs
  kotofetch
  networkmanager
  pipewire-alsa
  pipewire-pulse
  wireplumber
  mpd
  rmpc
  zoxide
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  xorg-fonts-100dpi
  xorg-fonts-75dpi
  xorg-fonts-encodings
  xorg-mkfontscale
  pay-respects
  quickshell-overview-git
  hyprmoncfg
  cargo
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  # All below for songrec
  pkgconf
  blueprint-compiler
  git
  gtk4
  libadwaita
  libsoup3
  alsa-lib
  libpulse
  libpipewire
  clang
  openssl
  ffmpeg
  gettext
  sed
  grep
)

DEPSRUNIT=(
  hyprland
  noctalia-git
  kitty
  neovim
  fastfetch
  fish
  curl
  fd
  starship
  power-profiles-daemon
  power-profiles-daemon-runit
  bluez
  bluez-runit
  bluez-utils
  eza
  git-lfs
  kotofetch
  networkmanager
  networkmanager-runit
  pipewire-alsa
  pipewire-runit
  pipewire-pulse
  pipewire-pulse-runit
  wireplumber
  wireplumber-runit
  mpd
  mpd-runit
  rmpc
  zoxide
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  xorg-fonts-100dpi
  xorg-fonts-75dpi
  xorg-fonts-encodings
  xorg-mkfontscale
  pay-respects
  quickshell-overview-git
  hyprmoncfg
  cargo
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  # All below for songrec
  pkgconf
  blueprint-compiler
  git
  gtk4
  libadwaita
  libsoup3
  alsa-lib
  libpulse
  libpipewire
  clang
  openssl
  ffmpeg
  gettext
  sed
  grep
)

DEPSOPENRC=(
  hyprland
  noctalia-git
  kitty
  neovim
  fastfetch
  fish
  curl
  fd
  starship
  power-profiles-daemon
  power-profiles-daemon-openrc
  bluez
  bluez-openrc
  bluez-utils
  eza
  git-lfs
  kotofetch
  networkmanager
  networkmanager-openrc
  pipewire-alsa
  pipewire-dinit
  pipewire-pulse
  pipewire-pulse-openrc
  wireplumber
  wireplumber-openrc
  mpd
  mpd-openrc
  rmpc
  zoxide
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  xorg-fonts-100dpi
  xorg-fonts-75dpi
  xorg-fonts-encodings
  xorg-mkfontscale
  pay-respects
  quickshell-overview-git
  hyprmoncfg
  cargo
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  # All below for songrec
  pkgconf
  blueprint-compiler
  git
  gtk4
  libadwaita
  libsoup3
  alsa-lib
  libpulse
  libpipewire
  clang
  openssl
  ffmpeg
  gettext
  sed
  grep
)

DEPSDINIT=(
  hyprland
  noctalia-git
  kitty
  neovim
  fastfetch
  fish
  curl
  fd
  starship
  power-profiles-daemon
  power-profiles-daemon-dinit
  bluez
  bluez-dinit
  bluez-utils
  eza
  git-lfs
  kotofetch
  networkmanager
  networkmanager-dinit
  pipewire-alsa
  pipewire-dinit
  pipewire-pulse
  pipewire-pulse-dinit
  wireplumber
  wireplumber-dinit
  mpd
  mpd-dinit
  rmpc
  zoxide
  noto-fonts
  noto-fonts-cjk
  noto-fonts-emoji
  xorg-fonts-100dpi
  xorg-fonts-75dpi
  xorg-fonts-encodings
  xorg-mkfontscale
  pay-respects
  quickshell-overview-git
  hyprmoncfg
  cargo
  xdg-desktop-portal
  xdg-desktop-portal-gtk
  xdg-desktop-portal-hyprland
  # All below for songrec
  pkgconf
  blueprint-compiler
  git
  gtk4
  libadwaita
  libsoup3
  alsa-lib
  libpulse
  libpipewire
  clang
  openssl
  ffmpeg
  gettext
  sed
  grep
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
INIT_SYSTEM=""

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

detect_init_system() {
  local comm
  comm=$(cat /proc/1/comm 2>/dev/null | tr -d '\n')

  case "$comm" in
  systemd) INIT_SYSTEM="systemd" ;;
  dinit) INIT_SYSTEM="dinit" ;;
  runit) INIT_SYSTEM="runit" ;;
  openrc-init | init)
    if [[ -d /etc/runit ]]; then
      INIT_SYSTEM="runit"
    elif [[ -d /etc/init.d ]]; then
      INIT_SYSTEM="openrc"
    elif command -v dinitctl &>/dev/null; then
      INIT_SYSTEM="dinit"
    else
      return 1
    fi
    ;;
  *) return 1 ;;
  esac
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

install_songrec() {
  log "Checking for songrec..."
  if command -v songrec &>/dev/null; then
    log "  songrec already installed, skipping"
    return
  fi
  log "Installing songrec via cargo..."
  if cargo install songrec --no-default-features -F gui,ffmpeg,pulse,pipewire,mpris; then
    log "  songrec installed successfully"
  else
    log "  WARNING: songrec install failed — you can retry with: cargo install songrec --no-default-features -F gui,ffmpeg,pulse,pipewire,mpris"
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
  if ! detect_init_system; then
    read -p " Could not detect init system. Choose: SystemD (1), OpenRC (2), Runit (3), Dinit (4): " choice
    case "$choice" in
    1) INIT_SYSTEM="systemd" ;;
    2) INIT_SYSTEM="openrc" ;;
    3) INIT_SYSTEM="runit" ;;
    4) INIT_SYSTEM="dinit" ;;
    *) die "Invalid choice" ;;
    esac
  else
    log "Detected init system: $INIT_SYSTEM"
  fi

  local -n selected_deps
  case "$INIT_SYSTEM" in
  systemd) selected_deps=DEPSSYSD ;;
  openrc) selected_deps=DEPSOPENRC ;;
  runit) selected_deps=DEPSRUNIT ;;
  dinit) selected_deps=DEPSDINIT ;;
  *) die "Unknown init system: $INIT_SYSTEM" ;;
  esac

  log "Installing dependencies via $AUR_HELPER..."

  if "$AUR_HELPER" -S --needed --noconfirm "${selected_deps[@]}"; then
    log "All dependencies installed successfully"
  else
    log "WARNING: Some packages failed to install — check the output above"
  fi

  install_rishot
}

make_directories() {
  log "Creating required directories..."
  mkdir -p "$CONFIG_DIR"
  mkdir -p "$CONFIG_DIR/fish"
  mkdir -p "$HOME/.local/share/noctalia/plugins"
}

clone_repo() {
  log "Cloning dotfiles repo..."

  if ! command -v git-lfs &>/dev/null; then
    log "  git-lfs not found, installing..."
    "$AUR_HELPER" -S --needed --noconfirm git-lfs || die "Failed to install git-lfs"
  fi

  git lfs install --skip-repo &>/dev/null

  if [[ -d "$CLONE_DIR" ]]; then
    log "  Repo already exists at $CLONE_DIR, pulling latest instead"
    git -C "$CLONE_DIR" pull
  else
    git clone "$REPO_URL" "$CLONE_DIR" || die "Clone failed"
  fi

  log "  Fetching LFS content (wallpapers, etc)..."
  if ! git -C "$CLONE_DIR" lfs pull; then
    log "  WARNING: git lfs pull failed — LFS-tracked files (e.g. Wallpapers) may still be pointer files"
  fi
}

copy_files() {
  log "Copying config files..."

  local pairs=(
    "hypr:$CONFIG_DIR/"
    "noctalia:$CONFIG_DIR/"
    "plugins:$HOME/.local/share/noctalia/"
    "fastfetch:$CONFIG_DIR/"
    "kitty:$CONFIG_DIR/"
    "nvim:$CONFIG_DIR/"
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

monitorslua() {
  FILE="$HOME/.config/hypr/monitors.lua"

  if [ -f "$FILE" ]; then
    log "monitors.lua already exists, skipping..."
  else
    log "monitors.lua not found, creating it..."
    mkdir -p "$(dirname "$FILE")"
    touch "$FILE"
  fi
}

main() {
  detect_aur_helper
  update_system
  check_noctalia
  install_deps
  install_songrec
  setup_path
  make_directories
  clone_repo
  copy_files
  monitorslua
  set_default_shell
  finish
}

main "$@"
