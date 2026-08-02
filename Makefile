# SPDX-License-Identifier: Apache-2.0
# SPDX-FileCopyrightText: 2026 The Linux Foundation

# Project-side build tooling for the fixture. docker-workflows'
# build_command escape hatch runs 'make images' to prove the
# enumerate-what-the-tooling-built path; the native path builds the
# same Dockerfiles directly.

NAMESPACE ?=
# Tolerate a trailing slash (common when pasting registry paths).
override NAMESPACE := $(patsubst %/,%,$(NAMESPACE))
TAG ?= local
BASE_IMAGE = $(if $(NAMESPACE),$(NAMESPACE)/)base-alpine:$(TAG)
CHILD_IMAGE = $(if $(NAMESPACE),$(NAMESPACE)/)chain-child:$(TAG)
UTIL_IMAGE = $(if $(NAMESPACE),$(NAMESPACE)/)util-echo:$(TAG)

.PHONY: images base child util test clean

images: base child util

base:
	docker build -t $(BASE_IMAGE) base-alpine

child: base
	docker build --build-arg BASE_IMAGE=$(BASE_IMAGE) \
		-t $(CHILD_IMAGE) chain-child

util:
	docker build -t $(UTIL_IMAGE) util-echo

test: images
	NAMESPACE=$(NAMESPACE) TAG=$(TAG) \
		tests/scripts/test_images.sh

clean:
	-docker rmi $(CHILD_IMAGE) $(BASE_IMAGE) $(UTIL_IMAGE)
