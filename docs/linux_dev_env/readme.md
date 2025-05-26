# Linux Based Dev Environment


# Usage 

## Option 1: Ephemeral 

### Nix (Recommended)

>  Ensure you have [nix](https://nixos.org/) installed and
> [flake](https://nixos.wiki/wiki/flakes) support enabled

> **IMPORTANT**: This is not a pure shell, do not make undesired changes to your
> system.

```bash
# change to linux_env root 
# cd linux_env

# start the shell 
# this will take some time to build
nix develop
```


### Docker 

> Ensure you have [docker](https://docs.docker.com/engine/install/) installed
> and the compose [plugin](https://docs.docker.com/compose/install/)

```bash
# change to linux_env root 
# cd linux_env 

# start the shell 
docker compose run --build dev && docker compose down
```

## Option 2: Installation

> **NOTE:** This script will only work on Debian12 & Arch Linux

```bash
# change to linux_env root 
# cd linux_env 

# install 
./scripts/linux_env.sh
```




# Overview

Linux dev environments typically have a ton of variability in the tools they
use, as well as each tool having many customization options themselves. If you are
interested in making an efficient setup, I'd recommend starting with something
like this, and then expirement with different tooling / settings until you find
a setup that checks all of your boxes.

Most of the tools used follow one of the initial UNIX philosiphies: _Do one
thing, and do it well._ Each tool has a role, and we'll go over each
of them. This isn't meant to be an exhaustive list, but rather some of the
important pieces most people have in their setup.

### Window Manager

One of the most important tools that most people don't talk about is your
[window manager](https://wiki.archlinux.org/title/Window_manager#Types). If
you're coming from Windows or MacOS, you may not have even heard of
them because the OS comes with one.

In a nutshell, window managers are the things that organize your application
windows on your screen. The reason they matter so much is that you'll typically
be moving between windows a lot. Even with multiple monitors, being able to
efficiently move to applications is critical. For my setup, I use
[Hyprland](https://wiki.archlinux.org/title/Hyprland), but feel free to use any
one you'd like.

### Terminal

Terminals are the piece of software that (roughyl) allow you to access your
shell. [Alacritty](https://alacritty.org/) is hardware accelerated and easy to
customize with TOML. Some other options include [Wezterm](https://wezterm.org/),
and the new [Ghostty](https://ghostty.org/). All three of these are great
options, some some of them may even remove the need for using a terminal
multiplexer. In this environment, we'll be using Alacritty because it is fast
and simple to customize.

### Shell

[Shells](https://wiki.archlinux.org/title/Command-line_shell) are programs that
allow you to run execute commands and easily control IO for those commands.
Shells can have wildly varying feature sets. Some are
[POSIX](https://en.wikipedia.org/wiki/POSIX) complient (e.g bash, zsh), and some
of them aren't (e.g fish). Your need for a POSIX complient shell will likely be
the governing factor in what shell you'll choose. Zsh is an excellent choice of
shell if you need a POSIX complient shell. Fish is an alternative shell focused
on simplicity that also includes a DSL which aims to simplify writing bash like
scripts. For this environment, we'll be using [fish](https://fishshell.com/)
along with [starship](https://starship.rs/) for our prompt.

### Terminal Multiplexer

[Terminal multiplexers](https://en.wikipedia.org/wiki/Terminal_multiplexer)
allow you to have multiple shell sessions per teminal session. They can be
useful for grouping related pieces of work (code + test flow), vertical or
horizontal splits, and especially helpful when your are SSHing into a machine
and need to run processes that aren't tied to the lifetime of the SSH session.
Tmux is a battle tested terminal multiplexer commonly found on machines (even
on Univserity CS machines). We'll be using tmux for this environment. If you
chose to use Ghostty as your terminal, you can take advantage of its built in
multiplexer for your own machines, but you'll miss the remote multiplexing.

### Editor

[Editors](https://en.wikipedia.org/wiki/Text_editor) are the programs we use to
write text. Text here could be anything from a TODO list to a python script
to get todays weather. The term "text editor" can be deceiving. They can as
simple as a program that soley lets you insert and delete text, to an IDE like
environment that includes autocompete, debug adapters, language servers, etc. I
believe that editors are the most personal piece of software running on a
system. Another persons keybinds and configuration may not work for you. My
recommendation for building your own editor would be to start with a core
feature set, keep track of the things that you find inefficient, and then add
components to solve those problems. Solving unecessary problems with plugins
leads to longer load times (even with lazy loading) and increases the likelyhood
of something breaking (intentially or not).

> **NOTE:** Depending on your usecase, some premade distros like
> [LazyVim](https://github.com/LazyVim/LazyVim) by the one and only
> [folke](https://github.com/folke)

For this environment, we'll use
[Neovim](https://wiki.archlinux.org/title/Neovim), a highly customizable text
editor that primarily uses lua for its configuration. Beyond the base
configuration provided, websites like [neovimcraft](https://neovimcraft.com/),
[dotfyle](https://dotfyle.com/neovim/plugins/trending), and
[awesome-neovim](https://github.com/rockerBOO/awesome-neovim) are excellent
resources for finding new plugins.

If you are keen on learning neovim, I'd recommend bookmarking the vim
[cheatsheet](https://vim.rtorr.com/), as well as using `vimtutor` and other
games to familiarize yourself with vim movements. I'd recommend turning off
movement plugins to get used to the standard movements, and then reintroduce
them to start flying around your buffers.

# Keybinds

## Tmux

> **Prefix Key:** `Ctrl-a`

---

| Key Combination          | Description                                    |
| ------------------------ | ---------------------------------------------- |
| `Prefix +  \|`           | Split window vertically (horizontal split)     |
| `Prefix + -`             | Split window horizontally (vertical split)     |
| `Prefix + H`             | Resize pane 5 cells left                       |
| `Prefix + J`             | Resize pane 5 cells down                       |
| `Prefix + K`             | Resize pane 5 cells up                         |
| `Prefix + L`             | Resize pane 5 cells right                      |
| `Prefix + C-l`           | Clear the screen                               |
| `Prefix + v` (copy mode) | Begin selection in copy-mode (vi-style)        |
| `Prefix + V` (copy mode) | Select entire line in copy-mode (vi-style)     |
| `Prefix + y` (copy mode) | Copy selection to system clipboard using xclip |

---

### Default tmux Key Bindings (Unchanged)

| Key Combination     | Description                  |
| ------------------- | ---------------------------- |
| `Prefix + c`        | Create new window            |
| `Prefix + ,`        | Rename current window        |
| `Prefix + &`        | Kill current window          |
| `Prefix + n`        | Next window                  |
| `Prefix + p`        | Previous window              |
| `Prefix + l`        | Last active window           |
| `Prefix + 0..9`     | Select window by number      |
| `Prefix + z`        | Toggle pane zoom             |
| `Prefix + o`        | Go to next pane              |
| `Prefix + q`        | Show pane numbers            |
| `Prefix + {`        | Move pane left               |
| `Prefix + }`        | Move pane right              |
| `Prefix + !`        | Break pane into a new window |
| `Prefix + x`        | Kill current pane            |
| `Prefix + d`        | Detach session               |
| `Prefix + [`        | Enter copy mode              |
| `Prefix + ]`        | Paste buffer                 |
| `Prefix + ?`        | Show key bindings            |
| `Prefix + t`        | Show clock                   |
| `Prefix + :`        | Command prompt               |
| `Prefix + Space`    | Next layout                  |
| `Prefix + Alt-1..5` | Select layout type           |
| `Prefix + f`        | Find window                  |
| `Prefix + w`        | List windows                 |
| `Prefix + s`        | List sessions                |
| `Prefix + D`        | Choose client                |
| `Prefix + r`        | Refresh client               |
| `Prefix + $`        | Rename session               |
| `Prefix + =`        | Choose buffer                |
| `Prefix + ~`        | Show message log             |

---

### Copy Mode (vi-style)

| Key in Copy Mode | Description                        |
| ---------------- | ---------------------------------- |
| `v`              | Begin selection                    |
| `V`              | Select entire line                 |
| `y`              | Copy selection to system clipboard |
| `q`              | Exit copy mode                     |
| `h/j/k/l`        | Move cursor left/down/up/right     |
| `/`              | Search forward                     |
| `n` / `N`        | Next/Previous search match         |

## Neovim

> **IMPORTANT:**  Only keybind overrides are shown here. See the original
> projects for a full range of keybinds for plugins



### Core

| Mode(s)                   | Keybind            | Description                                  |
| ------------------------- | ------------------ | -------------------------------------------- |
| n, i, v, s, x, c, o, l, t | `<C-j>`            | Escape key alternative                       |
| n, i, v, s, x, c, o, l, t | `<C-k>`            | Escape key alternative                       |
| n                         | `<leader>w`        | Save file                                    |
| n                         | `<leader><leader>` | Switch to last buffer                        |
| n                         | `<leader>,`        | Toggle hidden characters                     |
| n                         | `<leader>o`        | Open new file in current directory           |
| n                         | `n`                | Next search result (centered)                |
| n                         | `N`                | Previous search result (centered)            |
| n                         | `*`                | Search word under cursor (centered)          |
| n                         | `#`                | Search word under cursor backward (centered) |
| n                         | `g*`               | Search partial word under cursor (centered)  |
| n                         | `?`                | Very magic search backward                   |
| n                         | `/`                | Very magic search forward                    |
| c                         | `%s/`              | Substitute with magic                        |
| n, i                      | `<Up>`             | Disabled                                     |
| n, i                      | `<Down>`           | Disabled                                     |
| i                         | `<Left>`           | Disabled                                     |
| i                         | `<Right>`          | Disabled                                     |
| n                         | `<Left>`           | Previous buffer                              |
| n                         | `<Right>`          | Next buffer                                  |
| n                         | `j`                | Move down by visual line                     |
| n                         | `k`                | Move up by visual line                       |
| n                         | `<leader>m`        | Change text until underscore                 |
| (any)                     | `<F1>`             | Escape key                                   |
| i                         | `<F1>`             | Escape key                                   |
| (any)                     | `<C-p>`            | Find files                                   |
| n, v                      | `<C-c>`            | Clear search highlighting                    |
| n                         | `yc`               | Duplicate line and comment original          |
| n                         | `<CR>`             | Change inner word                            |
| v                         | `J`                | Move selected lines down                     |
| v                         | `K`                | Move selected lines up                       |
| n                         | `L`                | Go to end of line                            |
| n                         | `H`                | Go to start of line                          |
| n                         | `<leader>ll`       | Open Lazy                                    |

### Mason

| Mode | Keybind      | Description |
| ---- | ------------ | ----------- |
| n    | `<leader>mm` | Open Mason  |

### LSP

| Mode(s) | Keybind      | Description             |
| ------- | ------------ | ----------------------- |
| n       | `[d`         | Next Diagnostic         |
| n       | `]d`         | Previous Diagnostic     |
| n       | `gD`         | Declaration             |
| n       | `gd`         | Definition              |
| n       | `K`          | Hover Docs              |
| n       | `gi`         | Implementation          |
| n       | `<C-k>`      | Signature Help          |
| n       | `<leader>wa` | Add workspace folder    |
| n       | `<leader>wr` | Remove workspace folder |
| n       | `<leader>wl` | List Workspace Folder   |
| n       | `<space>D`   | Type Definition         |
| n       | `<leader>r`  | Rename                  |
| n, v    | `<leader>ca` | Code Action             |
| n       | `gr`         | References              |

### Conform

| Mode(s) | Keybind      | Description |
| ------- | ------------ | ----------- |
| n, v    | `<leader>cf` | Format Code |

### Neotree

| Mode(s) | Keybind          | Description             |
| ------- | ---------------- | ----------------------- |
| (any)   | `<LocalLeader>e` | Explorer NeoTree Toggle |
| (any)   | `<LocalLeader>a` | Explorer NeoTree Reveal |

### Silicon

| Mode(s) | Keybind      | Description                       |
| ------- | ------------ | --------------------------------- |
| v       | `<leader>sc` | Copy code screenshot to clipboard |
| v       | `<leader>sf` | Save code screenshot as file      |
| v       | `<leader>ss` | Create code screenshot            |


### Telescope

| Mode(s) | Keybind              | Description         |
| ------- | ------------------- | ------------------- |
| n       | `<localleader>ff`   | Find files          |
| n       | `<localleader>gf`   | Find Word           |
| n       | `<localleader>gg`   | Grep                |
| n       | `<localleader>b`    | Buffers             |
| n       | `<localleader>m`    | Marks               |
| n       | `<localleader>u`    | Spell suggest       |
| n       | `<localleader>x`    | Old files           |
| n       | `<localleader>;`    | Command history     |
| n       | `<localleader>:`    | Commands            |
| n       | `<localleader>/`    | Search history      |
| n       | `<leader>/`         | Buffer find         |
| n       | `<leader>sk`        | Key Maps            |
| n       | `<leader>sm`        | Man Pages           |


### Trouble

| Mode(s) | Keybind      | Description                            |
| ------- | ------------ | -------------------------------------- |
| n       | `<leader>xx` | Diagnostics (Trouble)                  |
| n       | `<leader>xX` | Buffer Diagnostics (Trouble)           |
| n       | `<leader>cs` | Symbols (Trouble)                      |
| n       | `<leader>cl` | LSP Definitions / references / ...     |
| n       | `<leader>xL` | Location List (Trouble)                |
| n       | `<leader>xQ` | Quickfix List (Trouble)                |


### Which-Key

| Mode(s) | Keybind     | Description                                |
| ------- | ----------- | ------------------------------------------ |
| n       | `<leader>?` | Buffer Local Keymaps (which-key)           |

### Icon Picker

| Mode(s) | Keybind     | Description                                |
| ------- | ----------- | ------------------------------------------ |
| n       | `<Leader>li`| Icon Picker (Icon Picker Normal)           |


### Flash

| Mode(s) | Keybind      | Description                            |
| ------- | ------------ | -------------------------------------- |
| n, x, o | `s`          | Flash                                  |
| n, x, o | `S`          | Flash Treesitter                       |
| o       | `r`          | Remote Flash                           |
| o, x    | `R`          | Treesitter Search                      |
| c       | `<c-s>`      | Toggle Flash Search                    |

### Spectre

| Mode(s) | Keybind      | Description                            |
| ------- | ------------ | -------------------------------------- |
| n       | `<leader>S`  | Toggle Spectre                         |

### Vim Tmux Navigator

| Mode(s) | Keybind   | Description               |
| ------- | --------- | ------------------------- |
| n       | `<C-h>`   | Navigate to left pane     |
| n       | `<C-j>`   | Navigate to below pane    |
| n       | `<C-k>`   | Navigate to above pane    |
| n       | `<C-l>`   | Navigate to right pane    |
| n       | `<C-\>`   | Navigate to previous pane |


