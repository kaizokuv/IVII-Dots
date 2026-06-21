<div align="center">
<h1>𝕀𝕍𝕀𝕀</h1>
</div>

<div align="center">
<h2> Demo Showcase </h2>
</div>

https://github.com/user-attachments/assets/30abbfa8-e7a1-4701-9f4f-42027ea9b1c6

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

File Manager - Dolphin (Moving to yazi soon)

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
cp -r ~/IVII-Dots/noctalia/ # for noctalia configurations
# Everything after this is optional
cp -r ~/IVII-Dots/fastfetch/ ~/.config/ # for fastfetch (dont if you want to keep yours)
cp -r ~/IVII-Dots/kitty/ ~/.config/ # if you use kitty and want it to look the same
cp -r ~/IVII-Dots/nvim/ ~/.config/ # installs lazyvim
cp -r ~/IVII-Dots/btop/ ~/.config/ # btop configs (looks and stuff)
cp -r ~/IVII-Dots/cava/ ~/.config/ # cava config
cp -r ~/IVII-Dots/starship.toml/ ~/.config/  # for starship terminal prompts
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
cp -r ~/IVII-Dots/noctalia/ # for noctalia configurations
# Everything after this is optional
cp -r ~/IVII-Dots/fastfetch/ ~/.config/ # for fastfetch (dont if you want to keep yours)
cp -r ~/IVII-Dots/kitty/ ~/.config/ # if you use kitty and want it to look the same
cp -r ~/IVII-Dots/nvim/ ~/.config/ # installs lazyvim
cp -r ~/IVII-Dots/btop/ ~/.config/ # btop configs (looks and stuff)
cp -r ~/IVII-Dots/cava/ ~/.config/ # cava config to match with noctalia colours
cp -r ~/
```

<div align="center">
<h2> Keybinds </h2>
</div>

I'm a big fan of saying "no" to the mouse, so just about anything you can think of has a bind. Here's a list of everything :D (Cheatsheet coming soon)


|Normal General/Random Stuff||
|---|---|
|Keybind|What it does|
|Super + Tab|Launcher|
|Super + I|Settings for Noctalia|
|Super + V|Clipboard|
|Super + Period|Emojis|
|Super + Q|Close Window|
|Super + Shift + Alt + Q|Forcefully Killing a Program|
|Super + Shift + S|Screenshot (Saves to clipboard, working on file output)|

|Noctalia Control Center Panels||
|---|---|
|Keybind|What it does|
|Super + N|Control Center Main Panel|
|Super + M|Media Panel|
|Super + A|Audio Panel|
|Super + Slash|Notifications Panel|
|Ctrl + Super + B|Bluetooth Panel|
|Ctrl + Super + W|Network Panel|
|Ctrl + Super + S|Systems Panel (System monitoring)|
|Ctrl + Super + C|Calender Panel|
|Shift + Super + W|Weather Panel|

|Wallpapers||
|---|---|
|Keybind|What it does|
|Ctrl + Super + T|Walpaper Panel|
|Super + Alt + T|Random Wallpaper|

|Toggles||
|---|---|
|Keybind|What it does|
|Shift + Super + C|Toggle Caffeine Mode (Disables Idling)|
|Ctrl + Super + P|Toggle Power Profiles (Needs power-profiles-daemon)|
|Ctrl + Super + D|Toggle Do Not Disturb Mode|

|Apps||
|---|---|
|Keybind|What it does|
|Super + W|Browser (Default is Brave, change in config to suit Your needs)|
|Super + Z|Zen Browser (I like to seperate work and personal life)|
|Super + P|Music Player (Default is Spotify, change in config to suit Your needs)|
|Super + Ctrl + V|Vesktop (Change to whatever your discord client is)|
|Super + E|File Manager (Default is Dolphin, change in config to suit Your needs)|

|Terminal Apps||
|---|---|
|Keybind|What it does|
|Super + Return / Super + T|Terminal ((Default is Kitty, change in config to suit Your needs)|
|Super + C|Neovim (Change it to any code editor tbh)|
|Super + B|Btop (I wasn't joking, i have keybinds for everything)|
|Ctrl + Super + L|[Late.sh](https://github.com/mpiorowski/late-sh)|

|Session Controls||
|---|---|
|Keybind|What it does|
|Super + L|Lock Screen|
|Shift + Super + L|Logout of Session|
|Shift + Super + R|Reboot|
|Ctrl + Alt + Delete|Session Panel|
|Ctrl + Shift + Alt + Super + Delete|Shutdown|

|Configuration Files||
|---|---|
|Keybind|What it does|
|Super + H|Hyprland.lua File|
|Super + K|Kitty.conf File|
|Ctrl + Super + F|Config.fish File|

|Special Workspace||
|---|---|
|Keybind|What it does|
|Super + S|Toggle Special Workspace|
|Super + Alt + S|Send Current Window to Special Workspace and Follows|

|Window Focusing/Movement/Others||
|---|---|
|Keybind|What it does|
|Super + Arrowkeys|Focus in that Direction|
|Super + Shift + Arrowkeys|Move Windows in that Direction|
|Super + F|Fullscreen|
|Super + D|Maximise|
|Shift + Super + P|Pin Window|
|Super + Semicolon|Reduce Split Ratio of Focused Window|
|Super + Apostrophe|Increase Split Ratio of Focused Window|
|Super + Alt + Space|Float Focused Window|
|Super + Left Mouse Button|Drag Window|
|Super + Right Mouse Button|Resize Window|

|Window Workspaces||
|---|---|
|Keybind|What it does|
|Super + Numberkey/Numpad Key|Go to Workspace|
|Super + Alt + Numberkey/Numpad Key|Send Focused Window to Workspace|
|Ctrl + Super + Left/Right Arrowkey|Move to Next/Previous Workspace|

|Touchpad Gestures (Laptops)||
|---|---|
|Gesture|What it does|
|3 Finger Swipe|Moves Focused Window in Swiped Direction|
|4 Finger Swipe|Changes Workspaces|

<div align="center">
<h2> Contributions </h2>
</div>

[End-4 Dotfiles](https://github.com/end-4/dots-hyprland) - These were my first dots that i used and were the base for about half of the keybinds and hyprland animations you see

[Noctalia](https://github.com/noctalia-dev/noctalia) - The shell, bloody gorgeous and an inspiration for my own shell to come
