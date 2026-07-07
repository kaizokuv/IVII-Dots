<div align="center">
<h1>𝕀𝕍𝕀𝕀</h1>
</div>

<div align="center">
<h2> Demo Showcase </h2>
</div>



<div align="center">
<h2> Screenshots </h2>
</div>




<div align="center">
<h2> Introduction </h2>
</div>

This is my own personal dotfiles I use on Artix Linux (Dinit init system). The shell is noctalia v5, and while i do love it i do plan to make my own at some point. The rest of the configurations are by me.

The dotfiles will include a copy of my hyprland.lua file, which has all the hyprland configurations, keybinds, layouts and stuff. Everything else is there for noctalia themeing (in theory).

Before you install, be warned i havent tested it myself so things may break (when i say test i mean outside of a machine that is my own)

The programs I'm using are listed below:

Terminal - Kitty

Shell - Fish

Bar - Noctalia v5

Browser - Brave

Music Player - Spotify

File Manager - Nemo (Moving to yazi soon)

Screen Recorder - OBS

Code Editor - LazyVim

<div align="center">
<h2> Installation </h2>
</div>

There is an install script on the way which will come soon (maybe), for now things will have to be done manually

```bash
git clone https://github.com/kaizokuv/IVII-Dots.git
cd IVII-Dots
# Copy the necessary files to ~/.config
cp -r ~/IVII-Dots/hypr/ ~/.config/ # for hyprland configs
cp -r ~/IVII-Dots/noctalia/ ~/.config/ # for noctalia configurations
# Everything after this is optional
cp -r ~/IVII-Dots/fastfetch/ ~/.config/ # for fastfetch (dont if you want to keep yours)
cp -r ~/IVII-Dots/kitty/ ~/.config/ # if you use kitty and want it to look the same
cp -r ~/IVII-Dots/nvim/ ~/.config/ # installs lazyvim
cp -r ~/IVII-Dots/btop/ ~/.config/ # btop configs (looks and stuff)
cp -r ~/IVII-Dots/cava/ ~/.config/ # cava config
cp -r ~/IVII-Dots/starship.toml/ ~/.config/  # for starship terminal prompts
cp -r ~/IVII-Dots/Wallpapers/ ~/Pictures/Wallpapers/ # for wallpapers (careful as it will replace your current folder if you have one so please backup first)
```

You will also need to install the following for things to work as seemlessly as they do for me

- hyprland
- kitty
- fish
- noctalia v5 (will be replaced eventually with my own shell)
- spotify
- brave
- neovim
- vesktop
- Nemo
- yazi (if you want this is still wip)
- zen browser (flatpak)
- power-profiles-daemon
- Vesktop
- [Late.sh](https://github.com/mpiorowski/late-sh)
- probably some others im forgetting :D

For starship, you will have to add this into your shell config (fish, bash, zsh)

Fish
```
starship init fish | source
```

Bash
```
eval "$(starship init bash)"
```

Zsh
```
eval "$(starship init zsh)"
```

<div align="center">
<h2> Updating </h2>
</div>

Now an update script uhhhhh.. maybe..? For now just follow this

```bash
cd IVII-Dots
git pull
# Copy the necessary files to ~/.config
cp -r ~/IVII-Dots/hypr/ ~/.config/ # for hyprland configs
cp -r ~/IVII-Dots/noctalia/ ~/.config/ # for noctalia configurations
# Everything after this is optional
cp -r ~/IVII-Dots/fastfetch/ ~/.config/ # for fastfetch (dont if you want to keep yours)
cp -r ~/IVII-Dots/kitty/ ~/.config/ # if you use kitty and want it to look the same
cp -r ~/IVII-Dots/nvim/ ~/.config/ # installs lazyvim
cp -r ~/IVII-Dots/btop/ ~/.config/ # btop configs (looks and stuff)
cp -r ~/IVII-Dots/cava/ ~/.config/ # cava config to match with noctalia colours
cp -r ~/IVII-Dots/starship.toml/ ~/.config/  # for starship terminal prompts
cp -r ~/IVII-Dots/Wallpapers/ ~/Pictures/Wallpapers/ # for wallpapers (careful as it will replace your current folder if you have one so please backup first)
```

<div align="center">
<h2> Keybinds </h2>
</div>

I'm a big fan of saying "no" to the mouse, so just about anything you can think of has a bind. Here's a list of some basics to get you started :D

|Keybind|What it does|
|---|---|
|Super + Tab|Launcher|
|Super + I|Settings for Noctalia|
|Super + N|Control Center Main Panel|
|Ctrl + Super + T|Wallpaper Panel|
|Super + Return / Super + T|Terminal ((Default is Kitty, change in config to suit Your needs)|
|Super + C|Neovim (Change it to any code editor tbh)|
|Super + W|Browser (Default is Brave, change in config to suit Your needs)|
|Super + E|File Manager (Default is Nemo, change in config to suit your needs)|
|Super + Q|Close Window|
|Super + Comma|Cheatsheat|

<div align="center">
<h2> Contributions </h2>
</div>

[End-4 Dotfiles](https://github.com/end-4/dots-hyprland) - These were my first dots that i used and were the base for about half of the keybinds and hyprland animations you see

[Noctalia](https://github.com/noctalia-dev/noctalia) - The shell, bloody gorgeous and an inspiration for my own shell to come
