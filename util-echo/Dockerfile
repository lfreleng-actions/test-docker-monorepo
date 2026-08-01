# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Linux Foundation

# Independent image with no chain relationship: proves the workflow
# handles mixed graphs (chained and standalone images side by side)
# and a second third-party base registry pull.
FROM busybox:1.37@sha256:9db7b59979c38555a39def84a31fb98b5296952f9e3afd4f6f11f05b07adfab0

LABEL org.opencontainers.image.title="test-docker-monorepo util-echo"
LABEL org.opencontainers.image.description="Fixture standalone image"
LABEL org.opencontainers.image.licenses="Apache-2.0"

USER 1000:1000

CMD ["echo", "util-echo fixture marker"]
