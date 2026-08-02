# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Linux Foundation

# Base image for the monorepo fixture. chain-child builds FROM this
# image's verify-lane tag, exercising same-repository FROM chains.
FROM alpine:3.22@sha256:14358309a308569c32bdc37e2e0e9694be33a9d99e68afb0f5ff33cc1f695dce

LABEL org.opencontainers.image.title="test-docker-monorepo base-alpine"
LABEL org.opencontainers.image.description="Fixture base image"
LABEL org.opencontainers.image.licenses="Apache-2.0"

RUN addgroup -g 1000 fixture && \
    adduser -S -u 1000 -G fixture fixture && \
    echo "base-alpine fixture marker" > /etc/fixture-base

USER 1000:1000

CMD ["cat", "/etc/fixture-base"]
