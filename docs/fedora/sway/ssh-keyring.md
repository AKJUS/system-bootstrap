# SSH Agent and Keyring Implementation (Fedora Sway)

## 1. Executive Summary

This document describes the setup of a modern SSH and secret management stack for Fedora Sway Spin. Unlike the GNOME edition, the Sway environment benefits from decoupling the Secret Service from the SSH Agent to utilize modern, maintained components.

**Objective**: Replace the legacy `gnome-keyring` SSH component with `gcr-ssh-agent`, while retaining `gnome-keyring` for the Secret Service API.

## 2. Architecture

We implement a split-responsibility model:

1.  **SSH Agent**: `gcr-ssh-agent` (part of GCR 4).
    *   *Reasoning*: More secure implementation, provides a better passphrase inquiry UI, and represents the modern standard for GTK-based environments.
2.  **Secret Store**: `gnome-keyring-daemon`.
    *   *Reasoning*: Currently the most reliable implementation of the DBus Secret Service API, necessary for storing encrypted credentials.

## 3. Implementation Guide

### 3.1 Dependencies

Ensure the requisite packages are present in the system image.

```bash
sudo dnf install gcr seahorse gnome-keyring
```

### 3.2 Service Configuration

We must modify the systemd user session to prefer the GCR agent.

**Step 1: Disable Legacy Agent**
Mask the gnome-keyring SSH component to prevent socket contention.

```bash
systemctl --user mask gnome-keyring-ssh.service gnome-keyring-ssh.socket
```

**Step 2: Enable Modern Agent**
Enable the socket activation for the GCR SSH agent.

```bash
systemctl --user enable --now gcr-ssh-agent.socket
```

### 3.3 Environment Injection

The Sway session does not automatically inherit SSH environment variables derived from systemd socket activation. We must manually bridge this gap.

**Sway Config (`~/.config/sway/config`):**
Import the `SSH_AUTH_SOCK` environment variable from the systemd user session into the Sway process environment.

```sway
# Import SSH socket variable to the session
exec systemctl --user import-environment SSH_AUTH_SOCK
```

**Shell Config (`~/.zshrc` or `~/.bash_profile`):**
Define the socket path for interactive shells.

```bash
# Explicitly point to the GCR socket
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
```

### 3.4 PAM Integration

Automated unlocking of the keyring is handled by PAM. On Fedora Sway Spin, the default `authselect` profile typically handles this correctly.

**Confirmation:**
Ensure `gnome-keyring-pam` is installed. When logging in via a Display Manager (SDDM/GDM), the "Login" keyring will automatically unlock if the login password matches the keyring password.

## 4. Verification

1.  **Restart Session**: Log out and log back in.
2.  **Check Socket Path**:
    ```bash
    echo $SSH_AUTH_SOCK
    # Expected: /run/user/<UID>/gcr/ssh
    ```
3.  **Check Agent Availability**:
    ```bash
    ssh-add -L
    # Should maintain exit code 0 or 1, not 2 (connection error).
    ```
