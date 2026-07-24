# fish-functions

A collection of productivity-focused Fish shell functions for Fedora Linux with GNOME: multi-agent AI sessions, AppImage installation, workspace management, and system updates.

## Requirements

- **Fish shell** (≥ 3.0) — all functions are written as native Fish functions
- **Fedora Linux** — `dnf` and `flatpak` paths reflect Fedora conventions
- **GNOME desktop** — `set-workspaces` uses GNOME-specific `gsettings` keys; `make-appimage` calls `update-desktop-database` and places icons in `~/.local/share`

### Per-function dependencies

| Function | Dependencies |
|---|---|
| `agentic-team` | [Goose AI CLI](https://github.com/block/goose), `~/Code/Personal/goose-configs/` (see [Notes](#notes)), `~/Code/Personal/goose-configs/STATE.md` |
| `make-appimage` | `sudo`, `cp`, `mv`, `chmod`, `mktemp`, `update-desktop-database` (from `desktop-file-utils`) |
| `set-workspaces` | `gsettings` (part of `glib2`) |
| `sys-update` | `sudo`, `dnf`, `flatpak` |

> **Tip:** Install `desktop-file-utils` if missing: `sudo dnf install desktop-file-utils`

## Installation

Add the functions directory to Fish's `$fish_function_path` in your `~/.config/fish/config.fish`:

```fish
# ~/.config/fish/config.fish
set -Ua fish_function_path ~/Code/Personal/fish-functions
```

Then reload Fish or start a new shell:

```bash
exec fish
```

Alternatively, copy the `.fish` files into `~/.config/fish/functions/` (Fish autoloads that directory by default).

## Usage

### `agentic-team` — Launch a Goose AI multi-agent session

Wires up a Goose AI session with DeepSeek, MOIM guardrails, and project state context from `goose-configs/`.

```
agentic-team <light|heavy> [goose_args...]
```

- **`light`** — uses `deepseek-v4-pro` with low thinking effort; fast, cost-efficient sessions
- **`heavy`** — uses `deepseek-v4-pro` with maximum thinking effort; deep reasoning sessions

Both modes:
- Set `GOOSE_PROVIDER=custom_deepseek`
- Concatenate `~/.config/goose/guardrails.md` + `STATE.md` into a MOIM context file
- Pass optional `goose_args` (e.g., `--resume`) transparently to `goose session`

**Examples:**

```fish
# Start a lightweight team session
agentic-team light

# Start a heavy reasoning session, resuming a previous one
agentic-team heavy --resume
```

### `make-appimage` — Install an AppImage into the system menu

Moves an AppImage to `~/AppImages/`, makes it executable, extracts its icon, and creates an XDG `.desktop` entry so it appears in the GNOME application menu.

```
make-appimage <path-to-appimage> "<App Name>"
```

- The file is renamed to a slugified version of the name (e.g., `"Capacities App"` → `capacities-app.AppImage`)
- The `.DirIcon` is extracted from the AppImage's `squashfs-root` and copied to `~/.local/share/icons/`
- A `.desktop` file is written to `~/.local/share/applications/`
- The desktop database is refreshed with `update-desktop-database`

**Examples:**

```fish
# Install an AppImage downloaded to ~/Downloads
make-appimage ~/Downloads/Capacities-2.0.AppImage "Capacities App"

# Install another
make-appimage ~/Downloads/Obsidian-1.8.9.AppImage "Obsidian"
```

**What happens behind the scenes:**

```
~/AppImages/capacities-app.AppImage     ← the moved executable
~/.local/share/icons/capacities-app.png ← extracted icon
~/.local/share/applications/capacities-app.desktop  ← menu entry
```

### `set-workspaces` — Set GNOME workspace names

Names GNOME workspaces in order via `gsettings`. Accepts any number of workspace names as positional arguments.

```
set-workspaces <name1> [name2 ... nameN]
```

**Examples:**

```fish
# Name three workspaces
set-workspaces Web Code Chat

# Name five
set-workspaces Web Code Chat Music Admin
```

> **Note:** GNOME must have at least as many workspaces as names provided, or extra names are ignored. Enable a fixed number of workspaces via:
> ```
> gsettings set org.gnome.mutter dynamic-workspaces false
> gsettings set org.gnome.desktop.wm.preferences num-workspaces 5
> ```

### `sys-update` — Full Fedora system update

Runs a complete update cycle in three stages, with success/failure reporting after each step:

1. **DNF upgrade** — `sudo dnf upgrade --refresh -y`
2. **Flatpak update** — `flatpak update -y --noninteractive`
3. **Flatpak cleanup** — `flatpak uninstall --unused -y`

```
sys-update
```

The function stops on failure: if `dnf` fails it returns before running Flatpak commands.

**Example:**

```fish
sudo sys-update
# Note: sys-update already calls sudo internally for dnf.
# Running "sudo sys-update" is harmless but unnecessary.
```

## Notes

### Linux specificity

All functions are **Linux-only**. In particular:
- `make-appimage` relies on `--appimage-extract` (AppImage runtime feature) and `update-desktop-database`
- `set-workspaces` writes GNOME `gsettings` keys
- `sys-update` calls `dnf` (Fedora's package manager)

They will **not** work on macOS or Windows (even under WSL without a GNOME session).

### `agentic-team` goose-configs dependency

The function concatenates `~/Code/Personal/goose-configs/STATE.md` into the MOIM context. If that directory or file does not exist, the session starts without project-state context. Clone it from your source repository:

```bash
git clone <your-goose-configs-repo> ~/Code/Personal/goose-configs
```

You also need `~/.config/goose/guardrails.md` — this is typically created by Goose's own setup (see the [Goose AI documentation](https://github.com/block/goose)).

### Shell compatibility

These are **Fish functions**, not POSIX shell scripts. Source them from Fish only. They cannot be sourced from Bash, Zsh, or other shells without adaptation.
