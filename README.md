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
├── version.properties           # project version (merge lane reads this)
├── base-alpine/Dockerfile       # base image (alpine, digest-pinned)
├── chain-child/Dockerfile       # FROM base-alpine — same-repo chain
├── util-echo/Dockerfile         # independent image (busybox, digest-pinned)
├── releases/1.2.3-container.yaml # container release descriptor
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
| Merge-lane version resolution           | `version.properties` carries the major/minor/patch trio, so the parser composes `1.2.3` and skips the `${...}` derived keys                          |
| Release detection and promotion         | `releases/1.2.3-container.yaml` names three staged images, overrides the pull registry port, and omits the push override to exercise the fallback    |

<!-- markdownlint-enable MD013 -->

## Local usage

```shell
make images   # build all three images (base first)
make test     # build + smoke-test
make clean    # remove the images
```

The images install no packages and run as non-root numeric users.

## Merge-lane fixtures

`version.properties` and `releases/1.2.3-container.yaml` serve
docker-workflows' merge lane, which builds images and publishes a
snapshot tag set on every merge, then promotes staged images when a
merged commit adds a container release file.

Both are inert for the verify lane: discovery looks for Dockerfiles,
and neither file changes what that lane finds.

Detection compares a merged commit against its parent, so the release
descriptor registers when a workflow checks out **the commit that
added it**. A caller exercising the promotion path pins that commit
rather than a moving branch.
