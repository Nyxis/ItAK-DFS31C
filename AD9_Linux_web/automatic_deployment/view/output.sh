#!/bin/bash

print_success() {
    echo "[SUCCESS] $1"
}

print_error() {
    echo "[ERROR] $1" >&2
}

print_info() {
    echo "[INFO] $1"
}

print_usage() {
    echo "Usage: $0 [-k nombre_de_releases] [-r repo_git] [-b branche_git] [-f dossier_git] {deploy|rollback}"
}