#!/bin/sh

# Script to generate SSL Certificates on base of existing Root CA certificated
# Usage
# $ ./domain.sh mysite.local www.mysite.local
# the second param is COMMON_NAME, it's optional

ORIG_PWD=$PWD
cd -- "$(dirname -- "$0")" || exit;

if [ -z "$1" ]; then
  echo "Please supply a subdomain to create a certificate for"
  echo "e.g. mysite.local"
  exit
fi

ROOT_CA_DIR="./../root"
ROOT_CA_KEY_PATH="${ROOT_CA_DIR}/rootCA.key"
ROOT_CA_PEM_PATH="${ROOT_CA_DIR}/rootCA.pem"

if [ ! -f "$ROOT_CA_KEY_PATH" ] || [ ! -f "$ROOT_CA_PEM_PATH" ]; then
  echo "Root CA key pair does not exist";
  echo "run './root_ca.sh to generate Root CA key pair'"
  exit;
fi

if [ -f device.key ]; then
  KEY_OPT="-key"
else
  KEY_OPT="-keyout"
fi

DOMAIN=$1
COMMON_NAME=${2:-$1}

SUBJECT="/C=CA/ST=None/L=NB/O=None/CN=${COMMON_NAME}"
NUM_OF_DAYS=365

echo "Generating Certificate Signing Request (device.csr)"
openssl req -new -newkey rsa:2048 -sha256 -nodes $KEY_OPT device.key -subj "$SUBJECT" -out device.csr

cmd < v3.ext | sed s/%%DOMAIN%%/"$COMMON_NAME"/g > /tmp/__v3.ext
echo "Generating domain certificate"
openssl x509 -req -in device.csr -CA "$ROOT_CA_PEM_PATH" -CAkey "$ROOT_CA_KEY_PATH" -CAcreateserial -out device.crt -days "$NUM_OF_DAYS" -sha256 -extfile /tmp/__v3.ext

DOMAIN_CERT_DIR="./../$DOMAIN"
if [ ! -d "$DOMAIN_CERT_DIR" ]; then
  mkdir "$DOMAIN_CERT_DIR"
fi

echo "Putting files to ${DOMAIN} directory"
mv device.csr "${DOMAIN_CERT_DIR}/${DOMAIN}.csr"
cp device.crt "${DOMAIN_CERT_DIR}/${DOMAIN}.crt"
cp device.key "${DOMAIN_CERT_DIR}/${DOMAIN}.key"

# remove temp file
rm -f device.crt device.csr

cd "$ORIG_PWD" || exit
