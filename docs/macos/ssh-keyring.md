# SSH Agent and Keychain Configuration (macOS)

## 1. Architecture Overview

macOS includes a fully integrated SSH agent and Keychain system out of the box.

*   **SSH Agent**: Native system service manageable via `launchd`.
*   **Secret Store**: macOS Keychain (Hardware-backed via Secure Enclave on supported devices).

## 2. Implementation Status

**No manual configuration is required.**

The system is designed to handle SSH keys and passphrases automatically. When you add a key with `ssh-add` (or use the `--apple-use-keychain` flag on newer versions), the passphrase is secured in the Keychain and unlocked seamlessly upon login.

### Verification
You can verify the agent is running by checking the socket variable in any terminal:

```zsh
echo $SSH_AUTH_SOCK
# Expected output: /private/tmp/com.apple.launchd.xxxxxx/Listeners
```
