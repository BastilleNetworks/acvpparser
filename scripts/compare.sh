#!/usr/bin/env bash
set -euo pipefail

BUNDLE_DIR=$(realpath "${1}")

rm "${BUNDLE_DIR}"/output/**/*

for EXPECTED_FILE in "${BUNDLE_DIR}"/expected/**/*.json; do
  RAW_FILE=$(echo "${EXPECTED_FILE}" | sed -e s/expected/raw/ | sed -e s/-expected//)
  OUT_FILE=$(echo "${RAW_FILE}" | sed -e s/raw/output/ -e s/json/diff/)
  if [ -f "${RAW_FILE}".partial ]; then
    echo "NOT FOUND: ${RAW_FILE}"
    continue
  fi
  echo COMPARING: "${EXPECTED_FILE}" to "${RAW_FILE} => ${OUT_FILE}"
  set +e
  jq -S . "${RAW_FILE}" | diff "${EXPECTED_FILE}" - > "${OUT_FILE}"
  set -e
done
