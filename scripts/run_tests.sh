#!/usr/bin/env bash
set -eu
SCRIPTS_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
ACVP_DIR=$(realpath "${SCRIPTS_DIR}"/..)
cd "${ACVP_DIR}"

BUNDLE_DIR=$(realpath "${1}")

make clean
make -s openssl

for GIVEN_FILE in "${BUNDLE_DIR}"/given/**/*.json; do
  RAW_FILE=$(echo "${GIVEN_FILE}" | sed -e s/given/raw/)
  echo RUNNING: ./acvp-parser "${GIVEN_FILE}" "${RAW_FILE}"
  set +e
  ./acvp-parser "${GIVEN_FILE}" "${RAW_FILE}"
  set -e
done

#tree "${BUNDLE_DIR}"
