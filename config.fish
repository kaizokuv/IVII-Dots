function fish_prompt -d "Write out the prompt"
    # This shows up as USER@HOST /home/user/ >, with the directory colored
    # $USER and $hostname are set by fish, so you can just use them
    # instead of using `whoami` and `hostname`
    printf '%s@%s %s%s%s > ' $USER $hostname \
        (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

if status is-interactive # Commands to run in interactive sessions can go here

    # No greeting
    set fish_greeting
    set -x QT_QPA_PLATFORMTHEME qt6ct
    set -x QT_STYLE_OVERRIDE Breeze

    fastfetch
    kotofetch
    echo

    # Use starship
    starship init fish | source
    zoxide init fish | source

    # Aliases
    alias pamcan pacman
    alias ls 'eza --icons'
    alias clear "printf '\033[2J\033[3J\033[1;1H'"
end

# Shortcuts Below

# Package Install/Remove/Update
alias install="yay -S"
alias remove="yay -Rns"
alias u="yay -Syyu pam pambase linux-zen linux-zen-headers -y && flatpak update -y && cargo install-update --all && killorphans && cache"

# SBCTL resiging
alias sbctlresign="sudo sbctl sign -s /boot/EFI/Artix/grubx64.efi && sudo sbctl sign -s /boot/EFI/BOOT/BOOTX64.EFI && sudo sbctl sign -s /boot/EFI/BOOT/grubx64.efi && sudo sbctl sign -s /boot/vmlinuz-linux-zen && sudo sbctl sign -s /boot/EFI/GRUB/grubx64.efi && sbctl sign -s /boot/EFI/visor/visor_x64.efi"

# Listing
alias orphans="yay -Qdtq"
alias pacinfo="yay -Qi"
alias paclist="yay -Qqe"
alias listdesktop="ls /usr/share/applications/"

# Cleanup orphan packages
function killorphans
    flatpak uninstall --unused
    yay -Qdtq | read -l orphans
    if test -n "$orphans"
        yay -Rns $orphans
    else
        echo "No orphaned packages found."
    end
    flatpak uninstall --unused
end

# Clean package cache
function cache
    set files /var/cache/pacman/pkg/download-*
    if test -e $files[1]
        sudo rm -rf $files
    end
    yay -Sc
end

function cachereset
    set files /var/cache/pacman/pkg/download-*
    if test -e $files[1]
        sudo rm -rf $files
    end
    yay -Scc
end

# nfzf
function nfzf
    while true
        set file (fd . --type f --hidden --exclude .git | fzf --preview 'bat --style=numbers --color=always {}' --preview-window=right:60%:wrap)
        if test -z "$file"
            break
        end
        nvim "$file"
    end
end

# Custom files
alias kittyconf="nvim ~/.config/kitty/kitty.conf"
alias fishconf="nvim ~/.config/fish/config.fish"
alias fastconf="nvim ~/.config/fastfetch/config.jsonc"
alias keydconf="sudo nvim /etc/keyd/default.conf"
alias btopconf="nvim ~/.config/btop/btop.conf"
alias hyprconf="nvim ~/.config/hypr/hyprland.lua"
alias pacmanconf="sudo nvim /etc/pacman.conf"
alias visorconf="sudo nvim /boot/EFI/visor/boot.conf"

#battery health
alias bathealth="upower -i /org/freedesktop/UPower/devices/battery_BAT0"

# wifi
alias w="cloudflare-speed-cli"

# sudo
alias sudo="sudo-rs"

function sudors --description "Switch to sudo-rs as main sudo"
    functions -e sudo 2>/dev/null
    alias sudo="sudo-rs"
    echo "Now using sudo-rs as main sudo"
end

function sudoc --description "Switch to classic sudo"
    functions -e sudo 2>/dev/null
    alias sudo="/usr/bin/sudo"
    echo "Now using classic sudo"
end

function sudowhich --description "Check which sudo is active"
    echo -n "Currently using: "
    sudo --version | head -n 1
end

# grub configs
alias egrubcfg="sudo nvim /etc/default/grub"
alias rgrubcfg="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# tor
alias toron="sudo dinitctl start tor"
alias toroff="sudo dinitctl stop tor"
alias torstatus="sudo dinitctl status tor"

# pacman lock
alias pidcheck="ps aux | grep pacman"
alias pidkill="sudo kill -9"
alias plockkill="sudo rm /var/lib/pacman/db.lck"

# hyprmod
function hyprmod
    pushd ~/hyprmod >/dev/null
    uv run hyprmod & disown
    popd >/dev/null
end

# system nuke
alias sysnukeslow="sudo shred --verbose --random-source=/dev/urandom --iterations=3 /dev/nvme0n1"
alias sysnukefast="sudo dd if=/dev/urandom of=/dev/nvme0n1 bs=1M status=progress"

# terminal apps
alias b="btop"

fish_add_path /home/kaizoku/.spicetify
fish_add_path /home/kaizoku/.cargo/bin
fish_add_path /home/kaizoku/.local/bin

pay-respects fish --alias | source

# uv
fish_add_path "/home/kaizoku/.local/bin"

# sddm setup
alias sddmsetup="z qylock && ./sddm.sh"

# config backups
alias hyprbackup="cp -r ~/.config/hypr/hyprland.lua ~/configbackups/"
alias fishbackup="cp -r ~/.config/fish/config.fish ~/configbackups/"
alias starshipbackup="cp -r ~/.config/starship.toml ~/configbackups/"
alias kittybackup="cp -r ~/.config/kitty/kitty.conf ~/configbackups/"
alias fastbackup="cp -r ~/.config/fastfetch/config.jsonc ~/configbackups/"
alias btopbackup="cp -r ~/.config/btop/btop.conf ~/configbackups/"
alias cavabackup="cp -r ~/.config/cava/config ~/configbackups/"
alias backupall="cp ~/.config/hypr/hyprland.lua ~/configbackups/ && cp -r ~/.config/fish/config.fish ~/configbackups/ && cp -r ~/.config/starship.toml ~/configbackups/ && cp -r ~/.config/kitty/kitty.conf ~/configbackups/ && cp -r ~/.config/fastfetch/config.jsonc ~/configbackups/ && cp -r ~/.config/btop/btop.conf ~/configbackups/ && cp -r ~/.config/cava/config ~/configbackups/"

# config restores
alias hyprrestore="cp -r ~/configbackups/hyprland.lua ~/.config/hypr/"
alias fishrestore="cp -r ~/configbackups/config.fish ~/.config/fish/"
alias starshiprestore="cp -r ~/configbackups/starship.toml ~/.config/"
alias kittyrestore="cp -r ~/configbackups/kitty/kitty.conf ~/.config/"
alias fastrestore="cp -r ~/configbackups/fastfetch/config.jsonc ~/.config/"
alias btoprestore="cp -r ~/configbackups/btop/btop.conf ~/.config/"
alias cavarestore="cp -r ~/configbackups/cava/config ~/.config/"
alias restoreall="cp -r ~/configbackups/hyprland.lua ~/.config/hypr/ && cp -r ~/configbackups/config.fish ~/.config/fish/ && cp -r ~/configbackups/starship.toml ~/.config/ && cp -r ~/configbackups/kitty/kitty.conf ~/.config/ && cp -r ~/configbackups/fastfetch/config.jsonc ~/.config/ && cp -r ~/configbackups/btop/btop.conf ~/.config/ && cp -r ~/configbackups/cava/config ~/.config/"

# pnpm
set -gx PNPM_HOME "/home/kaizoku/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
