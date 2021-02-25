#!/bin/sh

# Script to generate Root SSL Certificates

ORIG_PWD=$PWD
cd -- "$(dirname -- "$0")" || exit;

ROOT_CA_DIR="./../root"
ROOT_CA_KEY_PATH="${ROOT_CA_DIR}/rootCA.key"
ROOT_CA_PEM_PATH="${ROOT_CA_DIR}/rootCA.pem"

if [ -f "$ROOT_CA_KEY_PATH" ]; then
    echo "Root CA Key already exits. Overwrite? (y/n)"
    read -r answer

    if [ "$answer" = "${answer#[Yy]}" ] ;then
        echo "Nothing to create. Exiting."
        exit;
    else
        BACKUP_DIR="${ROOT_CA_DIR}.bk-$(date +%s)"
        echo "Backup existent Root CA to ${BACKUP_DIR}"
        mv -i "$ROOT_CA_DIR" "$BACKUP_DIR"
    fi
fi

if [ ! -d "$ROOT_CA_DIR" ]; then
  echo "Creating directory for Root CA"
  mkdir "$ROOT_CA_DIR"
fi

echo "Generating rootCA.key"
openssl genrsa -out "$ROOT_CA_KEY_PATH" 2048

echo "Generating rootCA.pem"
openssl req -x509 -new -nodes -key "$ROOT_CA_KEY_PATH" -sha256 -days 1024 -out "$ROOT_CA_PEM_PATH"

cd "$ORIG_PWD" || exit

