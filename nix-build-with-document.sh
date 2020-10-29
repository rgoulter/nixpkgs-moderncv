#!/usr/bin/env bash

set -ex

nix-build -E "with import <nixpkgs> {}; callPackage ./default.nix { document = ''$1''; }"
