#!/bin/sh

# This script installs the Nix package manager on your system by
# downloading a binary distribution and running its installer script
# (which in turn creates and populates /nix).

{ # Prevent execution if this script was only partially downloaded
oops() {
    echo "$0:" "$@" >&2
    exit 1
}

umask 0022

tmpDir="$(mktemp -d -t nix-binary-tarball-unpack.XXXXXXXXXX || \
          oops "Can't create temporary directory for downloading the Nix binary tarball")"
cleanup() {
    rm -rf "$tmpDir"
}
trap cleanup EXIT INT QUIT TERM

require_util() {
    command -v "$1" > /dev/null 2>&1 ||
        oops "you do not have '$1' installed, which I need to $2"
}

case "$(uname -s).$(uname -m)" in
    Linux.x86_64)
        hash=cc9cf4b3111a93db6322bc5c5ecf40f1de3be2414c82f252bd2e2b2b6419d706
        path=bxkxkdmh6c0z2mry0jrdp8mzgh906dyv/nix-2.10.1-x86_64-linux.tar.xz
        system=x86_64-linux
        ;;
    Linux.i?86)
        hash=2fb4ef12868c460f8982d49a6ca9fefa733f4a112cabfed11300d7e4bdd8122b
        path=5bmp2c91n42w9rz5shpiy0mww53j416l/nix-2.10.1-i686-linux.tar.xz
        system=i686-linux
        ;;
    Linux.aarch64)
        hash=7e513f0f78fc8730163ef561b4ec380c6bfb3d96a4a1fbb36ef070890a236562
        path=v6pa0gcw1jz622jg89a727v2zn0w8aa8/nix-2.10.1-aarch64-linux.tar.xz
        system=aarch64-linux
        ;;
    Linux.armv6l_linux)
        hash=a135763d831d5b91deaff852db31d70c6d0f7a7c80ef421348c8990e13c61571
        path=5gw2x499dn416sy5kfnhghw79ky4yq9y/nix-2.10.1-armv6l-linux.tar.xz
        system=armv6l-linux
        ;;
    Linux.armv7l_linux)
        hash=9e817ea475f64e5fb4eb833660a9ef66aa4687f4b0febb62b81c2d0bdc5fe329
        path=fvn2h8h7za0slz9dk5jwhvmcchsik7nd/nix-2.10.1-armv7l-linux.tar.xz
        system=armv7l-linux
        ;;
    Darwin.x86_64)
        hash=7851ac90e7de9ce02f3f951444da5a272e2596fb82b81b6d5966905d54e56dbb
        path=znwxla6px8cjrym05j81l9sc2srj9klb/nix-2.10.1-x86_64-darwin.tar.xz
        system=x86_64-darwin
        ;;
    Darwin.arm64|Darwin.aarch64)
        hash=823ccea1d8837fbf9f6c1f890be0530b63aff648b7a2e870b9e5a2c4539afb06
        path=fr13hhbvvr6za48l0q2812gc4k6fccpv/nix-2.10.1-aarch64-darwin.tar.xz
        system=aarch64-darwin
        ;;
    *) oops "sorry, there is no binary distribution of Nix for your platform";;
esac

# Use this command-line option to fetch the tarballs using nar-serve or Cachix
if [ "${1:-}" = "--tarball-url-prefix" ]; then
    if [ -z "${2:-}" ]; then
        oops "missing argument for --tarball-url-prefix"
    fi
    url=${2}/${path}
    shift 2
else
    url=https://releases.nixos.org/nix/nix-2.10.1/nix-2.10.1-$system.tar.xz
fi

tarball=$tmpDir/nix-2.10.1-$system.tar.xz

require_util tar "unpack the binary tarball"
if [ "$(uname -s)" != "Darwin" ]; then
    require_util xz "unpack the binary tarball"
fi

if command -v curl > /dev/null 2>&1; then
    fetch() { curl --fail -L "$1" -o "$2"; }
elif command -v wget > /dev/null 2>&1; then
    fetch() { wget "$1" -O "$2"; }
else
    oops "you don't have wget or curl installed, which I need to download the binary tarball"
fi

echo "downloading Nix 2.10.1 binary tarball for $system from '$url' to '$tmpDir'..."
fetch "$url" "$tarball" || oops "failed to download '$url'"

if command -v sha256sum > /dev/null 2>&1; then
    hash2="$(sha256sum -b "$tarball" | cut -c1-64)"
elif command -v shasum > /dev/null 2>&1; then
    hash2="$(shasum -a 256 -b "$tarball" | cut -c1-64)"
elif command -v openssl > /dev/null 2>&1; then
    hash2="$(openssl dgst -r -sha256 "$tarball" | cut -c1-64)"
else
    oops "cannot verify the SHA-256 hash of '$url'; you need one of 'shasum', 'sha256sum', or 'openssl'"
fi

if [ "$hash" != "$hash2" ]; then
    oops "SHA-256 hash mismatch in '$url'; expected $hash, got $hash2"
fi

unpack=$tmpDir/unpack
mkdir -p "$unpack"
tar -xJf "$tarball" -C "$unpack" || oops "failed to unpack '$url'"

script=$(echo "$unpack"/*/install)

[ -e "$script" ] || oops "installation script is missing from the binary tarball!"
export INVOKED_FROM_INSTALL_IN=1
"$script" "$@"

} # End of wrapping
