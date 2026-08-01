#!/usr/bin/env bash
# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Linux Foundation

# Smoke-tests the fixture images. Environment:
#   NAMESPACE  optional image namespace prefix
#   TAG        image tag (default: local)
# docker-workflows' test_command hook runs this with TAG=verify.

set -euo pipefail

TAG="${TAG:-local}"
NAMESPACE="${NAMESPACE:-}"
# Tolerate a trailing slash (common when pasting registry paths).
NAMESPACE="${NAMESPACE%/}"
prefix=""
if [ -n "${NAMESPACE}" ]; then
  prefix="${NAMESPACE}/"
fi

echo "Testing ${prefix}base-alpine:${TAG}"
output=$(docker run --rm "${prefix}base-alpine:${TAG}")
grep -q "base-alpine fixture marker" <<< "${output}"

echo "Testing ${prefix}util-echo:${TAG}"
output=$(docker run --rm "${prefix}util-echo:${TAG}")
grep -q "util-echo fixture marker" <<< "${output}"

echo "Testing ${prefix}chain-child:${TAG}"
output=$(docker run --rm "${prefix}chain-child:${TAG}")
# Both markers must be present: the child layers on the base image
# built earlier in the same run, proving the FROM chain worked.
grep -q "base-alpine fixture marker" <<< "${output}"
grep -q "chain-child fixture marker" <<< "${output}"

echo "All fixture image tests passed ✅"
