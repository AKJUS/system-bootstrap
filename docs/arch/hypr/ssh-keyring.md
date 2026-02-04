# SSH Agent and Keyring Implementation (Arch Linux + Hyprland)

## 1. System Overview

Arch Linux follows a "Do It Yourself" philosophy. Consequently, no secret management or SSH agent is configured by default. This document specifies the manual construction of a `gcr` + `gnome-keyring` stack.

## 2. Architecture Specification

*   **Secret Store**: `gnome-keyring-daemon` (handling the DBus Secret Service standard).
*   **SSH Integration**: `gcr-ssh-agent` (Modern GCR 4 implementation).
*   **Authentication**: PAM (Pluggable Authentication Modules) hooks to auto-unlock the keyring upon user login.

## 3. Configuration Procedure

### 3.1 Software Installation

Primary packages required for the stack:

```bash
sudo pacman -S gcr seahorse gnome-keyring
```

### 3.2 Service Orchestration

We must explicitly define which agent owns the SSH environment.

1.  **Deactivate Legacy Service**:
    Arch's `gnome-keyring` package ships with unit files that may default to "on". Mask them to prevent conflicts.
    ```bash
    systemctl --user mask gnome-keyring-ssh.service gnome-keyring-ssh.socket
    ```

2.  **Activate Modern Service**:
    Enable the socket for the GCR agent.
    ```bash
    systemctl --user enable --now gcr-ssh-agent.socket
    ```

### 3.3 Environment Setup

Integration with Hyprland requires explicit variable declaration and export.

**1. Hyprland Configuration (`hyprland.conf`)**
Add the following to your startup configuration to register the variable and update systemd's awareness of it.

```ini
# SSH Agent Socket
env = SSH_AUTH_SOCK,$XDG_RUNTIME_DIR/gcr/ssh

# Import environment to systemd user session (crucial for services started by systemd)
exec-once = systemctl --user import-environment SSH_AUTH_SOCK
```

**2. Interactive Shell (`.zshrc` / `.bashrc`)**
Ensures terminal sessions pick up the correct socket immediately.

```bash
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
```

### 3.4 PAM Configuration (Critical Path)

This is the most error-prone step in Arch. We must manually edit the PAM configuration to enable the "Login" keyring unlock.

**Target File**: `/etc/pam.d/login` (if using TTY login) OR your Display Manager config (e.g., `/etc/pam.d/sddm` or `/etc/pam.d/greetd`).

**Required Edits:**

1.  **Authentication Stack (`auth`)**:
    Add this line at the end of the `auth` section (usually after `system-local-login`).
    ```
    auth       optional     pam_gnome_keyring.so
    ```

2.  **Session Stack (`session`)**:
    Add this line at the end of the `session` section.
    ```
    session    optional     pam_gnome_keyring.so auto_start
    ```

*Note: Ensure `auto_start` is present. It triggers the daemon if it's not already running.*

## 4. Keyring Initialization

1.  Launch **Seahorse** (`seahorse`).
2.  If prompted, create a **Default Keyring** (often named "Login").
3.  **Constraint**: The password for this keyring **MUST** match your user login password. If they differ, PAM cannot auto-unlock the keyring, and you will be prompted for a password at every boot.

## 5. Validation

To certify the setup:

1.  **Reboot**.
2.  Open a terminal.
3.  Run `echo $SSH_AUTH_SOCK`. It must return: `/run/user/<UID>/gcr/ssh`.
4.  Run `ssh-add -l`. It should return "The agent has no identities" (exit code 1) or a list of keys (exit code 0), but **NOT** "Could not open a connection onto your authentication agent" (exit code 2).
