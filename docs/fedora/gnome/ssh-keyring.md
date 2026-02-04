# GNOME Keyring and SSH Agent Configuration (Fedora Workstation)

## 1. Architecture Overview

Fedora Workstation (GNOME edition) utilizes a strictly integrated approach to secret management and SSH identity handling.

-   **Secret Management**: Handled by **gnome-keyring-daemon**.
-   **SSH Agent**: Provided by the `ssh` component of `gnome-keyring-daemon`.
-   **Session Management**: `gnome-session` automatically initializes the daemon and environment variables.

### Design Rationale
For a vertically integrated desktop environment like GNOME, using the built-in keyring for both secrets (passwords) and SSH keys is preferred to minimize component fragmentation. It ensures that unlocking the user session (via GDM) automatically unlocks the SSH keys without additional user intervention.

## 2. Implementation Status

**No manual configuration is required.**

Fedora Workstation ships with this configuration enabled out-of-the-box. The systemd user units and socket activation are pre-configured by the distribution maintainers.

### System Components
The following packages are responsible for this functionality:
-   `gnome-keyring`: The main daemon.
-   `gnome-keyring-pam`: PAM module for auto-unlocking.

## 3. Verification

To verify the system is behaving as expected, ensure the `SSH_AUTH_SOCK` environment variable points to the keyring socket.

### Validation Steps
Run the following command in a terminal:

```bash
echo $SSH_AUTH_SOCK
```

**Expected Output:**
```text
/run/user/<UID>/keyring/ssh
```

If the output matches, the SSH requests are correctly routed to the GNOME Keyring daemon.
