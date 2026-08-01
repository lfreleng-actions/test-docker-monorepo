<!--
SPDX-License-Identifier: Apache-2.0
SPDX-FileCopyrightText: 2026 The Linux Foundation
-->

# 🐳 Test Docker Monorepo

<!-- prettier-ignore-start -->
<!-- markdownlint-disable-next-line MD013 -->
[![Linux Foundation](https://img.shields.io/badge/Linux-Foundation-blue)](https://linuxfoundation.org/) [![Source Code](https://img.shields.io/badge/GitHub-100000?logo=github&logoColor=white&color=blue)](https://github.com/lfreleng-actions/test-docker-monorepo) [![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
<!-- prettier-ignore-end -->

Multi-image Docker monorepo **test fixture** for
[docker-workflows](https://github.com/lfreleng-actions/docker-workflows).
Not a useful project in itself: its layout exists to exercise the
paths a reusable Docker build workflow must handle.

## Layout

```text
test-docker-monorepo/
├── Makefile                     # project-side tooling (build_command path)
├── base-alpine/Dockerfile       # base image (alpine, digest-pinned)
├── chain-child/Dockerfile       # FROM base-alpine — same-repo chain
├── util-echo/Dockerfile         # independent image (busybox, digest-pinned)
└── tests/scripts/test_images.sh # smoke tests (test_command path)
```

## What it exercises

<!-- markdownlint-disable MD013 -->

| Behaviour                               | How                                                                                                                                                  |
| --------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| Multi-image discovery                   | three per-image directories                                                                                                                          |
| Build ordering / same-repo `FROM` chain | `chain-child` builds `FROM base-alpine:verify` (the tag the verify lane gives the base); directory names sort so discovery order satisfies the chain |
| Chain verification                      | the child's container output combines its own marker with the inherited base marker                                                                  |
| Mixed graphs                            | `util-echo` has no chain relationship                                                                                                                |
| Explicit `images` input                 | callers can pass the three images with `build_args` overriding `BASE_IMAGE`                                                                          |
| `build_command` escape hatch            | `make images` builds via project tooling                                                                                                             |
| `test_command` hook                     | `TAG=verify tests/scripts/test_images.sh`                                                                                                            |
| Lint/scan lanes                         | Dockerfiles are hadolint-clean; digest-pinned bases keep scans reproducible                                                                          |

<!-- markdownlint-enable MD013 -->

## Local usage

```shell
make images   # build all three images (base first)
make test     # build + smoke-test
make clean    # remove the images
```

The images install no packages and run as non-root numeric users.
