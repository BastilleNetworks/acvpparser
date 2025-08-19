#!/usr/bin/env bash
set -euo pipefail

BUNDLE_DIR=$(realpath "${1}")

for FILE in "${BUNDLE_DIR}"/*; do
  mkdir -p "${BUNDLE_DIR}/expected"
  mkdir -p "${BUNDLE_DIR}/given"
  mkdir -p "${BUNDLE_DIR}/raw"
  mkdir -p "${BUNDLE_DIR}/output"
  if [[ "${FILE}" =~ ^"${BUNDLE_DIR}"/(expected|given|raw|output)$ ]]; then
    continue
  fi
  if [[ "${FILE}" == *-expected ]]; then
    TARGET=$(echo "${FILE}" | sed -e s/-expected// | sed -E 'sX/([^/]+)$X/expected/\1X')
    echo $FILE "=>" $TARGET
    mv "${FILE}" "${TARGET}"
  else
    TARGET=$(echo "${FILE}" |  sed -E 'sX/([^/]+)$X/given/\1X')
    echo $FILE "=>" $TARGET
    mv "${FILE}" "${TARGET}"
  fi
done

for GIVEN in "${BUNDLE_DIR}"/given/*; do
  RAW=$(echo "${GIVEN}" | sed -E 's/given/raw/')
  mkdir -p "${RAW}"
  OUTPUT=$(echo "${GIVEN}" | sed -E 's/given/output/')
  mkdir -p "${OUTPUT}"
done

for GIVEN_FILE in "${BUNDLE_DIR}"/given/**/*.json; do
  jq '[ {"acvVersion": "1.0"}, .]' "${GIVEN_FILE}" > /tmp/testvector-request.json
  mv /tmp/testvector-request.json "${GIVEN_FILE}"
done

for EXPECTED_FILE in "${BUNDLE_DIR}"/expected/**/*.json; do
  jq '[ {"acvVersion": "1.0"}, .]' "${EXPECTED_FILE}" > /tmp/testvector-response.json
  mv /tmp/testvector-response.json "${EXPECTED_FILE}"
done

tree "${BUNDLE_DIR}"
