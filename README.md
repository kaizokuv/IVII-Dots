<div align="center">
<h1>𝕀𝕍𝕀𝕀</h1>
<img alt="GitHub repo size" src="https://img.shields.io/github/repo-size/kaizokuv/IVII-Dots?style=for-the-badge&logo=Files&logoColor=%236082B6"> <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/kaizokuv/IVII-Dots?display_timestamp=committer&style=for-the-badge&logo=git&logoColor=%236082B6"> <img alt="GitHub License" src="https://img.shields.io/github/license/kaizokuv/IVII-Dots?style=for-the-badge&logo=github&logoColor=%236082B6">
</div>

<div align="center">
<h2> Demo Showcase </h2>
</div>

https://github.com/user-attachments/assets/8e4a5430-51bb-4bba-83f8-e71d7a093b7e

<div align="center">
<h2> Screenshots </h2>
</div>

<div align="center">
<table>
<tr>
<td align="center">
<img src="assets/photos/image1.jpeg" width="450"><br>
<b>The Ricing Screenshot :D</b><br>
</td>

<td align="center">
<img src="assets/photos/image2.jpeg" width="450"><br>
<b>Settings and Notepad</b><br>
</td>
</tr>

<tr>
<td align="center">
<img src="assets/photos/image3.jpeg" width="450"><br>
<b>Oooooooooh Music~</b><br>
</td>

<td align="center">
<img src="assets/photos/image4.png" width="450"><br>
<b>Well Isn't This Calming...</b><br>
</td>
</tr>
</table>
</div>

<div align="center">
<h2> Introduction </h2>
</div>

This is my own personal dotfiles I use on Artix Linux (Dinit init system). The shell is noctalia v5, and while i do love it i do plan to make my own at some point. The rest of the configurations are by me.

The dotfiles will include a copy of my hyprland.lua file, which has all the hyprland configurations, keybinds, layouts and stuff.

The programs I'm using are listed below:

Terminal - Kitty

Shell - Fish

Bar - Noctalia v5

Browser - Brave

Music Player - Spotify

File Manager - Nemo

Screen Recorder - OBS

Code Editor - LazyVim

Screenshot Tool - [Rishot](https://github.com/Gakuseei/rishot)

<div align="center">
<h2> Installation </h2>
</div>

THERE IS NOW AN INSTALL SCRIPT!!!
As of now, it only works on Arch and its derivatives (sorry everyone else, I'm working on it ;w;)

Make sure you also have yay or paru installed

Just follow these instructions and the dots will work just fine (hopefully), if they don't just hmu with an issue

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/kaizokuv/IVII-Dots/main/installer.sh)"
```

And if that doesn't work, then just use the commands below and it'll do the exact same thing

```bash
git clone https://github.com/kaizokuv/IVII-Dots.git
cd IVII-Dots
chmod +x installer.sh
./installer.sh
```

Now if you don't trust the script (I don't blame you), just do it the manual way then

Before installing, please make sure that you have [Noctalia V5](https://noctalia.dev/) installed

```bash
git clone https://github.com/kaizokuv/IVII-Dots.git
cd ~/IVII-Dots
git lfs pull
# Copy the necessary files to ~/.config
cp -r ~/IVII-Dots/hypr/ ~/.config/ # for hyprland configs
cp -r ~/IVII-Dots/noctalia/ ~/.config/ # for noctalia configurations
cp -r ~/IVII-Dots/plugins ~/.local/share/noctalia/ # for plugins
cp -r ~/IVII-Dots/fastfetch/ ~/.config/ # for fastfetch (dont if you want to keep yours)
cp -r ~/IVII-Dots/kitty/ ~/.config/ # if you use kitty and want it to look the same
cp -r ~/IVII-Dots/nvim/ ~/.config/ # installs lazyvim
cp -r ~/IVII-Dots/rmpc/ ~/.config/ # for rmpc music player client
cp ~/IVII-Dots/starship.toml ~/.config/  # for starship terminal prompts
cp ~/IVII-Dots/config.fish ~/.config/fish/ # fish config
cp -r ~/IVII-Dots/Wallpapers ~/
touch ~/.config/hypr/monitors.lua # for multi monitor configuration via hyprmoncfg
sudo chmod +x installer.sh
./installer.sh
```

You will also need to install the following for things to work as seemlessly as they do for me (do install them before cloning the repo)

- hyprland
- kitty
- fish
- neovim
- power-profiles-daemon
- [Rishot](https://github.com/Gakuseei/rishot)
- [quickshell-overview](https://github.com/Shanu-Kumawat/quickshell-overview)
- kotofetch
- zoxide
- pay-respects
- hyprmoncfg
- git-lfs
- [SongRec](https://github.com/marin-m/SongRec)
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

For updating just follow this

```bash
cd IVII-Dots
git pull
git lfs pull
# Copy the necessary files to ~/.config
cp -r ~/IVII-Dots/hypr/ ~/.config/ # for hyprland configs
cp -r ~/IVII-Dots/noctalia/ ~/.config/ # for noctalia configurations
cp -r ~/IVII-Dots/plugins ~/.local/share/noctalia/ # for plugins
cp -r ~/IVII-Dots/fastfetch/ ~/.config/ # for fastfetch (dont if you want to keep yours)
cp -r ~/IVII-Dots/kitty/ ~/.config/ # if you use kitty and want it to look the same
cp -r ~/IVII-Dots/nvim/ ~/.config/ # installs lazyvim
cp -r ~/IVII-Dots/rmpc/ ~/.config/ # for rmpc music player client
cp ~/IVII-Dots/starship.toml ~/.config/  # for starship terminal prompts
cp ~/IVII-Dots/config.fish ~/.config/fish/ # fish config
cp -r ~/IVII-Dots/Wallpapers ~/ # Wallpapers
sudo chmod +x installer.sh
./installer.sh
```

Or just re-run the install script :D

<div align="center">
<h2> Keybinds and Aliases </h2>
</div>

I'm a big fan of saying "no" to the mouse, so just about anything you can think of has a bind. Here's a list of some basics to get you started :D

|Keybind|What it does|
|---|---|
|Super + Tab|Launcher|
|Super + I|Settings for Noctalia|
|Super + N|Control Center Main Panel|
|Ctrl + Super + T|Wallpaper Panel|
|Super + Return |Terminal|
|Super + C|Code Editor|
|Super + W|Browser|
|Super + E|File Manager|
|Super + Q|Close Window|
|Super + Comma|Cheatsheet|

In addition, I do also have some maybe useful aliases (they are very to me so yeah), and the most common ones you can see listed below, if you want to see them all they're in config.fish

|Alias|What it does|
|---|---|
|u|Full system update (yay -Syyu && killorphans && cache)|
|install|yay -S|
|remove|yay -Rns|
|pacinfo|Gives info on a package (yay -Qi)|
|paclist|List all installed packages (yay -Qqe)|
|killorphans|Removes all orphaned packages|
|cache|Clears your cache|

<div align="center">
<h2> Being Worked on/fixing </h2>
</div>

If you guys have any suggestions on what to add or what needs fixing just open a github issue, but for now this is whats being done behind the scenes.

Being worked on:
- Making the dots and plugins be WM-Agnostic to work on all WMs (Hyprland, Niri, Mango, etc..)
- Making the dots more modular (custom files for custom keybinds and rules)

Being fixed:
- Lockscreen being on the default

<div align="center">
<h2> Disclaimer </h2>
</div>

While I did make most of these configs myself, I did use Claude for some light work, such as merging everything into one folder to push and manage easily (previously it was all over the place), as well as some of the code, making sure there are no bugs for the configs and the custom plugin, so some of the code is AI-generated, just gotta be transparent

In addition, these dots does not deal with services, it it mainly to get you started on hyprland by dealing with stuff like window rules and keybinds, startups for the shell and other things, you will have to manage your services and programs and whatnot yourself

<div align="center">
<h2> Contributions </h2>
</div>

[End-4 Dotfiles](https://github.com/end-4/dots-hyprland) - These were my first dots that i used and were the base for about half of the keybinds and hyprland animations you see

[Noctalia](https://github.com/noctalia-dev/noctalia) - The shell, bloody gorgeous and an inspiration for my own shell to come

[Gakuseei](https://github.com/Gakuseei/rishot) - The maker of Rishot, love this tool

[Shanu-Kumawat](https://github.com/Shanu-Kumawat/quickshell-overview) - For the quickshell overview tool, the most perfect one i found for my flow

[SongRec](https://github.com/marin-m/SongRec) - The backbone of the Songrec plugin

[Light-em](https://github.com/light-em/Archer) - The inspiration of the RMPC config (I took it and remodelled it for my liking ;w;..)

<div align="center">
<h2> Copying and License </h2>
</div>

Yeah I'm gonna be honest, do whatever you want, take it, use it, modify it, but if you gonna yoink some stuff, just be sure to give contribution thanks to me and the people I've given thanks to, since mine, and by right, yours too if you decide to yoink this, wouldn't exist without them and their work
