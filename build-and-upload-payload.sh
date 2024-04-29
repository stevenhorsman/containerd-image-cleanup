#!/usr/bin/env bash
#
# Copyright (c) 2024 IBM Corporation
#
# SPDX-License-Identifier: Apache-2.0
#

[ -z "${DEBUG}" ] || set -x
set -o errexit
set -o nounset
set -o pipefail
set -o errtrace

REGISTRY="${REGISTRY:-"quay.io/stevenhorsman"}"
TAG="${TAG:-$(git rev-parse HEAD)}"

docker buildx build \
--push \
--platform linux/amd64,linux/s390x \
--tag "${REGISTRY}"/containerd-image-cleanup:"${TAG}" .
