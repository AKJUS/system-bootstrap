#!/usr/bin/env zsh

# openSUSE SDDM setup for Wayland + Sway
#
# SDDM runs as the system 'sddm' user (home: /var/lib/sddm/).
# Its Sway greeter session is completely separate from the regular user session —
# kanshi and ~/.config/sway/config are never consulted at the login screen.
# Output rotation / resolution must be configured here.
#
# See: docs/suse/sway/sddm-wayland.md

set -euo pipefail

echo "------------------------------------------------------------"
echo "Setting up SDDM greeter Sway config..."
echo "------------------------------------------------------------"

SDDM_SWAY_DIR="/var/lib/sddm/.config/sway"

# --- 1. Create config directory ---
sudo mkdir -p "$SDDM_SWAY_DIR"

# --- 2. Write minimal greeter Sway config ---
# Adjust output names / transforms to match your hardware.
# Output names can be found with: swaymsg -t get_outputs | grep name
sudo tee "$SDDM_SWAY_DIR/config" > /dev/null <<'EOF'
# SDDM greeter sway config
# Managed by: scripts/opensuse/03-sddm.sh
# Do NOT edit manually — re-run the script instead.

# HDMI-A-1: Elgato Cam Link / primary 4K display (no rotation)
output HDMI-A-1 {
    mode 3840x2160
    pos 0 0
}

# HDMI-A-2: Dell monitor — physically rotated 90°
output HDMI-A-2 {
    mode 2560x1440@120hz
    transform 90
    pos 3840 0
}
EOF

# --- 3. Fix ownership ---
sudo chown -R sddm:sddm /var/lib/sddm/.config/

# --- 4. Verify /etc/sddm.conf has CompositorCommand=sway ---
if ! grep -qr "CompositorCommand" /etc/sddm.conf /etc/sddm.conf.d/ 2>/dev/null; then
    echo "WARNING: CompositorCommand not found in SDDM config."
    echo "Ensure /etc/sddm.conf or /etc/sddm.conf.d/ contains:"
    echo "  [Wayland]"
    echo "  CompositorCommand=sway"
fi

echo "------------------------------------------------------------"
echo "Restarting SDDM..."
echo "------------------------------------------------------------"
sudo systemctl restart sddm

echo "------------------------------------------------------------"
echo "SDDM greeter config applied."
echo "  Config written to: $SDDM_SWAY_DIR/config"
echo "  Owner: $(stat -c '%U:%G' "$SDDM_SWAY_DIR/config")"
echo "------------------------------------------------------------"
