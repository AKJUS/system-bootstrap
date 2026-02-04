# SSH Agent and Keyring Implementation (openSUSE Sway)

## 1. Abstract

This document outlines the standard operating procedure for configuring SSH identity management on openSUSE Tumbleweed/Leap within a Sway window manager session. The goal is to establish a secure, modern agent environment (`gcr-ssh-agent`) while maintaining seamless secret storage (`gnome-keyring`).

## 2. Component Architecture

### Core Components
| Component | Function | Status |
|-----------|----------|--------|
| **gcr-ssh-agent** | SSH Identity Agent | **Enabled** (Primary) |
| **gnome-keyring** | Secret Storage Service | **Enabled** (Secrets only) |
| **gnome-keyring-ssh** | Legacy SSH Agent | **Masked** (Disabled) |

### Rationale
openSUSE defaults often enable the legacy `gnome-keyring` SSH agent. We deliberately disable this in favor of `gcr-ssh-agent` to leverage better security practices and modern codebase support provided by the GCR 4 library.

## 3. Deployment Steps

### 3.1 Package Provisioning
Install the required agent, GUI tools, and PAM modules.

```bash
sudo zypper install gcr seahorse gnome-keyring pam_gnome_keyring
```

### 3.2 Systemd User Configuration
Safely transition responsibility from the legacy agent to the GCR agent.

1.  **Stop existing services**:
    ```bash
    systemctl --user stop gnome-keyring-ssh.service gnome-keyring-ssh.socket
    ```
2.  **Permanently Mask**:
    ```bash
    systemctl --user mask gnome-keyring-ssh.service gnome-keyring-ssh.socket
    ```
3.  **Enable Modern Agent**:
    ```bash
    systemctl --user enable --now gcr-ssh-agent.socket
    ```

### 3.3 Session Environment
Configure the session to utilize the specific GCR socket.

**Config file**: `~/.profile` (or `~/.zshrc`)
```bash
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
```

**Config file**: `~/.config/sway/config`
Ensure the environment variable is propagated to child processes spawned by Sway (like application launchers).

```sway
exec_always systemctl --user import-environment SSH_AUTH_SOCK
```

### 3.4 PAM Authentication (Critical)
openSUSE uses `pam-config` to manage authentication modules. This step is required for "Single Sign-On" behavior—unlocking the keyring with your login password.

**Execution:**
```bash
sudo pam-config --add --gnome_keyring
```

**Verification:**
Inspect `/etc/pam.d/common-auth` or `/etc/pam.d/sddm`. It must contain:
> `auth optional pam_gnome_keyring.so`

Inspect `/etc/pam.d/common-session`. It must contain:
> `session optional pam_gnome_keyring.so auto_start`

## 4. Operational Verification

1.  **Reboot** the machine to ensure a clean session start.
2.  **Socket Check**:
    ```bash
    ls -la $SSH_AUTH_SOCK
    ```
    *Result*: Should verify the existence of the socket file in `/run/user/...`
3.  **UI Check**:
    Open `seahorse`. Ensure a keyring named **Login** exists and is unlocked (padlock icon is open).
