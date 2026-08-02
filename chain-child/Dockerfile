# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Linux Foundation

# Builds FROM the base image produced earlier in the same repository.
# The default matches the tag the docker-workflows verify lane gives
# the base-alpine image; the Makefile and publish lanes override
# BASE_IMAGE with their own tag/namespace.
#
# hadolint cannot resolve the ARG-carried reference and would raise
# DL3006 (untagged image) despite the tagged default.
ARG BASE_IMAGE=base-alpine:verify
# hadolint ignore=DL3006
FROM ${BASE_IMAGE}

LABEL org.opencontainers.image.title="test-docker-monorepo chain-child"
LABEL org.opencontainers.image.description="Fixture child image (FROM chain)"
LABEL org.opencontainers.image.licenses="Apache-2.0"

# Combining a child marker with the inherited base marker proves the
# container really layers on the base built earlier in the same run.
USER 0:0
RUN echo "chain-child fixture marker" > /etc/fixture-child
USER 1000:1000

CMD ["cat", "/etc/fixture-base", "/etc/fixture-child"]
