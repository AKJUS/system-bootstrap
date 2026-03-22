# SDDM on Wayland + Sway (openSUSE)

SDDM is a **system-level component** — its config lives in `/etc/` and `/var/lib/sddm/`, not
in userspace dotfiles. Dotbot cannot manage these paths. Automation must be handled via a
dedicated script with `sudo`.

---

## How it works

`/etc/sddm.conf` sets `CompositorCommand=sway`, meaning SDDM launches Sway as its Wayland
greeter compositor. It runs under the **`sddm` system user**, whose home is `/var/lib/sddm/`.

The SDDM Sway session is completely isolated from the regular user session:
- it never reads `~/.config/sway/config`
- it never runs kanshi or any user services
- output configuration (rotation, resolution) must be declared in the `sddm` user's own Sway config

---

## Active config on this machine

### `/etc/sddm.conf`
```ini
[Theme]
Current=silent

[General]
InputMethod=qtvirtualkeyboard
GreeterEnvironment=QML2_IMPORT_PATH=/usr/share/sddm/themes/silent/components/,QT_IM_MODULE=qtvirtualkeyboard,QT_WAYLAND_SHELL_INTEGRATION=layer-shell
DisplayServer=wayland

[Wayland]
EnableHiDPI=true
CompositorCommand=sway
```

### `/etc/sddm.conf.d/10-wayland.conf`
```ini
[General]
DisplayServer=wayland
GreeterEnvironment=QT_WAYLAND_SHELL_INTEGRATION=layer-shell

[Wayland]
EnableHiDPI=true
CompositorCommand=XDG_SESSION_TYPE=wayland XDG_CURRENT_DESKTOP=sway sway
```

> Note: `sddm.conf.d/` snippets are merged. The `10-wayland.conf` snippet sets a more explicit
> `CompositorCommand` with env vars. This takes precedence per snippet ordering.

---

## Output rotation at the greeter

The `HDMI-A-2` (`$DELL`) display requires `transform 90` (as seen in kanshi config). Without a
sddm-user sway config this transform is not applied at the login screen.

### Manual setup

```bash
# 1. Create the config dir for the sddm user
sudo mkdir -p /var/lib/sddm/.config/sway

# 2. Write a minimal sway config with output rotation
sudo tee /var/lib/sddm/.config/sway/config <<'EOF'
# SDDM greeter sway config
# Managed by: scripts/opensuse/03-sddm.sh
# Do NOT edit manually — re-run the script instead.

xwayland disable

output HDMI-A-1 {
    mode 3840x2160
    pos 0 0
}

output HDMI-A-2 {
    mode 2560x1440@120hz
    transform 90
    pos 3840 0
}
EOF

# 3. Fix ownership
sudo chown -R sddm:sddm /var/lib/sddm/.config/

# 4. Restart SDDM
sudo systemctl restart sddm
```

### Find output names (from a running Sway session)

```bash
swaymsg -t get_outputs | grep name
# or check kanshi config:
cat ~/.config/kanshi/config
```

---

## Automation

All of the above is automated in `scripts/opensuse/03-sddm.sh`. Run it after the base
package install step:

```bash
just opensuse-sddm
```

The script is idempotent — safe to re-run.

---

## Troubleshooting

| Symptom | Cause | Fix |
|---------|-------|-----|
| Login screen shows on wrong/rotated display | No sddm sway config | Run `03-sddm.sh` |
| SDDM fails to start Wayland session | `CompositorCommand` missing `sway` in PATH | Check `/etc/sddm.conf.d/` ordering |
| Theme not loading | `/usr/share/sddm/themes/silent` missing | `sudo zypper in sddm-theme-silent` (or equivalent) |
| Changes not applied after edit | SDDM already running | `sudo systemctl restart sddm` |

---

## Why not Dotbot?

Dotbot symlinks files into `~` (the calling user's home). Paths under `/etc/` and
`/var/lib/sddm/` require `sudo` and belong to a different user (`sddm`). A shell script
with explicit `sudo` commands is the right tool for system-level config like this.
