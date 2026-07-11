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
alias u="yay -Syyu && killorphans && cache"

# Listing
alias orphans="yay -Qdtq"
alias pacinfo="yay -Qi"
alias paclist="yay -Qqe"
alias listdesktop="ls /usr/share/applications/"

# Cleanup orphan packages
function killorphans
    yay -Qdtq | read -l orphans
    if test -n "$orphans"
        yay -Rns $orphans
    else
        echo "No orphaned packages found."
    end
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

#battery health
alias bathealth="upower -i /org/freedesktop/UPower/devices/battery_BAT0"

# wifi
alias w="cloudflare-speed-cli"

# grub configs
alias egrubcfg="sudo nvim /etc/default/grub"
alias rgrubcfg="sudo grub-mkconfig -o /boot/grub/grub.cfg"

# pacman lock
alias pidcheck="ps aux | grep pacman"
alias pidkill="sudo kill -9"
alias plockkill="sudo rm /var/lib/pacman/db.lck"

pay-respects fish --alias | source

# pnpm
set -gx PNPM_HOME "~/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
    set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
