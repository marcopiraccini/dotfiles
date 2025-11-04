# Terminal Configuration Guide

This repository includes configurations for two modern terminal emulators: **Kitty** and **Ghostty**. Both are configured with consistent keybindings, Dracula theme, and FiraCode Nerd Font.

## Table of Contents

- [Kitty Configuration](#kitty-configuration)
- [Ghostty Configuration](#ghostty-configuration)
- [Common Keybindings](#common-keybindings)
- [Differences Between Kitty and Ghostty](#differences-between-kitty-and-ghostty)
- [Troubleshooting](#troubleshooting)

---

## Kitty Configuration

**Location**: `.config/kitty/kitty.conf`

### Features

- **Theme**: Dracula (via `Dracula.conf`)
- **Font**: FiraCode Nerd Font Mono, 14pt
- **Layout**: Splits layout enabled
- **Remote Control**: Enabled for advanced scripting
- **Tab Bar**: Top position with separator style

### Kitty-Specific Settings

```bash
# Include Dracula theme
include ./Dracula.conf

# Layouts
enabled_layouts splits

# Remote control
allow_remote_control yes

# Tab bar
tab_bar_style separator
tab_separator " ┇ "
tab_bar_edge top
```

### Installation

```bash
# Ubuntu/Debian
sudo apt install kitty

# Or download latest release
curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
```

---

## Ghostty Configuration

**Location**: `.config/ghostty/config`

### Features

- **Theme**: Dracula (inline color palette)
- **Font**: FiraCode Nerd Font Mono, 14pt
- **Shell Integration**: Zsh
- **Window Management**: Split support

### Ghostty-Specific Settings

```bash
# Inline Dracula colors
background = 282a36
foreground = f8f8f2
palette = 0=#21222c
palette = 1=#ff5555
# ... (full palette defined in config)

# Shell integration
shell-integration = zsh

# Performance
resize-overlay = never
```

### Installation

```bash
# Download from GitHub releases
# https://github.com/ghostty-org/ghostty

# Follow platform-specific instructions
```

---

## Common Keybindings

Both terminals use `ctrl+shift` as the modifier key (equivalent to `kitty_mod`).

### Window Splitting

| Action | Keybinding | Description |
|--------|-----------|-------------|
| New vertical split | `ctrl+shift+enter` or `ctrl+shift+\` | Split window vertically (new pane to the right) |
| New horizontal split | `ctrl+shift+-` | Split window horizontally (new pane below) |

### Window Navigation

| Action | Keybinding | Description |
|--------|-----------|-------------|
| Next split/window | `ctrl+shift+]` | Move to next split |
| Previous split/window | `ctrl+shift+[` | Move to previous split |
| Move to split | `shift+up/down/left/right` | Jump to specific split direction |

### Window Resizing

| Action | Keybinding | Description |
|--------|-----------|-------------|
| Resize left | `ctrl+h` | Make split wider (move divider left) |
| Resize right | `ctrl+l` | Make split narrower (move divider right) |
| Resize up | `ctrl+k` | Make split taller |
| Resize down | `ctrl+j` | Make split shorter |

### Tab Management

| Action | Keybinding | Description |
|--------|-----------|-------------|
| New tab | `ctrl+shift+t` | Create new tab |
| Close tab | `ctrl+shift+q` | Close current tab |
| Next tab | `ctrl+shift+right` or `ctrl+shift+l` | Switch to next tab |
| Previous tab | `ctrl+shift+left` or `ctrl+shift+h` | Switch to previous tab |
| Set tab title | `ctrl+shift+i` | Set custom tab/window title |

### Scrolling

| Action | Keybinding | Description |
|--------|-----------|-------------|
| Scroll up (line) | `ctrl+shift+up` or `ctrl+shift+k` | Scroll one line up |
| Scroll down (line) | `ctrl+shift+down` or `ctrl+shift+j` | Scroll one line down |
| Scroll page up | `ctrl+shift+page_up` | Scroll one page up |
| Scroll page down | `ctrl+shift+page_down` | Scroll one page down |
| Scroll to top | `ctrl+shift+home` | Jump to scrollback top |
| Scroll to bottom | `ctrl+shift+end` | Jump to scrollback bottom |

### Font Size

| Action | Keybinding | Description |
|--------|-----------|-------------|
| Increase font | `ctrl+shift+up` (Kitty) / `ctrl++` (Ghostty) | Make text larger |
| Decrease font | `ctrl+shift+down` (Kitty) / `ctrl+-` (Ghostty) | Make text smaller |
| Reset font | `ctrl+shift+backspace` (Kitty) / `ctrl+shift+0` (Ghostty) | Reset to default size |

### Clipboard

| Action | Keybinding | Description |
|--------|-----------|-------------|
| Copy | `ctrl+shift+c` or `super+c` | Copy to clipboard |
| Paste | `ctrl+shift+v` or `super+v` | Paste from clipboard |
| Paste selection | `ctrl+shift+s` or `shift+insert` | Paste from selection |

### Miscellaneous

| Action | Keybinding | Description |
|--------|-----------|-------------|
| Quick terminal (Ghostty) | `ctrl+shift+p` | Toggle quick terminal |
| Clear scrollback (Kitty) | `ctrl+shift+delete` | Clear scrollback buffer |

---

## Differences Between Kitty and Ghostty

### Feature Comparison

| Feature | Kitty | Ghostty |
|---------|-------|---------|
| **Theme Loading** | External file (`Dracula.conf`) | Inline color definitions |
| **Shell Integration** | Automatic | Explicit (zsh, bash, fish) |
| **Remote Control** | Full API support | Limited |
| **Tab/Window Titles** | `set_tab_title` | `prompt_surface_title` |
| **Layout Rotation** | `ctrl+shift+tab` | Not available |
| **Performance** | Excellent | Excellent (Zig-based) |
| **GPU Acceleration** | Yes | Yes |
| **Ligatures** | Full support | Full support |
| **Image Protocol** | Yes | In development |

### Configuration Syntax

**Kitty** uses a more traditional syntax:
```bash
map kitty_mod+enter new_window_with_cwd
font_size 14.0
```

**Ghostty** uses key=value pairs:
```bash
keybind = ctrl+shift+enter=new_split:right
font-size = 14
```

### Theme Management

**Kitty**:
- Themes stored in separate files
- Include with `include ./Dracula.conf`
- Easy to switch themes

**Ghostty**:
- Colors defined inline in main config
- Can also use external theme files in `~/.config/ghostty/themes/`
- Currently requires manual color definition or theme download

---

## Troubleshooting

### Font Issues

If FiraCode Nerd Font doesn't work:

```bash
# Install Nerd Fonts
./bin/install-fonts.sh

# Or manually:
mkdir -p ~/.local/share/fonts
# Download and extract FiraCode Nerd Font to that directory
fc-cache -fv
```

### Kitty: Clipboard Not Working

```bash
# Ensure xclip or wl-clipboard is installed
sudo apt install xclip  # For X11
sudo apt install wl-clipboard  # For Wayland
```

### Ghostty: Config Not Loading

```bash
# Verify config location
ls -la ~/.config/ghostty/config

# Check for syntax errors
ghostty --help  # Should show no config errors in output
```

### Ghostty: Shell Integration Not Working

Make sure `.zshrc` is properly configured:
```bash
# Shell integration is loaded automatically if:
shell-integration = zsh
# is set in ghostty config
```

### Kitty: Remote Control Permission Denied

```bash
# Ensure remote control is enabled in config
allow_remote_control yes

# Set socket for communication
listen_on unix:/tmp/kitty
```

### Split Keybindings Not Working

1. **Check modifier key**: Ensure `ctrl+shift` works in your system
2. **Terminal focus**: Make sure the terminal window has focus
3. **Conflicting keybindings**: Check if other apps intercept these keys

---

## Additional Resources

### Kitty

- [Official Documentation](https://sw.kovidgoyal.net/kitty/)
- [Kitty Themes](https://github.com/dexpota/kitty-themes)
- [Remote Control](https://sw.kovidgoyal.net/kitty/remote-control/)

### Ghostty

- [GitHub Repository](https://github.com/ghostty-org/ghostty)
- [Official Website](https://ghostty.org/)
- [Configuration Documentation](https://ghostty.org/docs/config)

### Dracula Theme

- [Dracula Official](https://draculatheme.com/)
- [Kitty Dracula](https://draculatheme.com/kitty)

### Fonts

- [Nerd Fonts](https://www.nerdfonts.com/)
- [FiraCode](https://github.com/tonsky/FiraCode)
