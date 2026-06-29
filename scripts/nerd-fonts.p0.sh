#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CONFIG_PATH="${NERDFONT_CONFIG:-${REPO_ROOT}/.files/.config/nerd-config-installer/config.yaml}"
INSTALL_DIR="${NERDFONT_INSTALLER_BIN_DIR:-${HOME}/.local/bin}"
INSTALLER="${INSTALL_DIR}/nerdfont-install"
INSTALLER_REPO="${NERDFONT_INSTALLER_REPO:-worxbend/nerd-font-installer}"

detect_os() {
    case "$(uname -s)" in
        Linux) echo "linux" ;;
        Darwin) echo "darwin" ;;
        *)
            echo "Unsupported OS: $(uname -s)" >&2
            return 1
            ;;
    esac
}

detect_arch() {
    case "$(uname -m)" in
        x86_64 | amd64) echo "amd64" ;;
        arm64 | aarch64) echo "arm64" ;;
        *)
            echo "Unsupported architecture: $(uname -m)" >&2
            return 1
            ;;
    esac
}

install_nerdfont_installer() {
    local os arch archive workdir base_url

    os="$(detect_os)"
    arch="$(detect_arch)"
    archive="nerdfont-install_latest_${os}_${arch}.tar.gz"
    base_url="https://github.com/${INSTALLER_REPO}/releases/download/latest"
    workdir="$(mktemp -d)"

    trap 'rm -rf "${workdir}"' RETURN

    mkdir -p "${INSTALL_DIR}"
    curl -fsSLo "${workdir}/${archive}" "${base_url}/${archive}"
    curl -fsSLo "${workdir}/checksums.txt" "${base_url}/checksums.txt"

    (
        cd "${workdir}"
        if command -v sha256sum >/dev/null 2>&1; then
            sha256sum --check --ignore-missing checksums.txt
        fi
        tar -xzf "${archive}"
        find . -type f -name nerdfont-install -exec chmod +x {} \; -exec mv {} "${INSTALLER}" \;
    )

    if [ ! -x "${INSTALLER}" ]; then
        echo "Downloaded archive did not contain nerdfont-install" >&2
        exit 1
    fi
}

if [ ! -f "${CONFIG_PATH}" ]; then
    echo "Nerd Font installer config not found: ${CONFIG_PATH}" >&2
    exit 1
fi

if ! command -v nerdfont-install >/dev/null 2>&1 && [ ! -x "${INSTALLER}" ]; then
    install_nerdfont_installer
fi

if command -v nerdfont-install >/dev/null 2>&1; then
    exec nerdfont-install --config "${CONFIG_PATH}"
fi

exec "${INSTALLER}" --config "${CONFIG_PATH}"
