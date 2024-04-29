#!/usr/bin/env bash
# Copyright 2024 Intel
# Copyright (c) 2024 IBM Corporation
#
# SPDX-License-Identifier: Apache-2.0
#

chroot host

test_images_to_remove=(
        "docker.io/rancher/mirrored-pause"
        "registry.k8s.io/pause"
        "docker.io/library/nginx"
        "quay.io/sjenning/nginx"
        "quay.io/prometheus/busybox"
        "quay.io/confidential-containers/test-images"
)

ctr_args="--namespace k8s.io"
ctr_command="ctr ${ctr_args}"
echo "::group::Found matching images already existing..."
for related_image in "${test_images_to_remove[@]}"; do
        # We need to delete related image
        image_list=($(chroot /host /bin/bash -c "${ctr_command} i ls -q" |grep "$related_image" |awk '{print $1}'))
        if [ "${#image_list[@]}" -gt 0 ]; then
                for image in "${image_list[@]}"; do
                        chroot /host /bin/bash -c "${ctr_command} i remove "$image""
                done
        fi

        # We need to delete related content of image
        IFS="/" read -ra parts <<< "$related_image";
        repository="${parts[0]}";
        image_name="${parts[1]}";
        formatted_image="${parts[0]}=${parts[-1]}"
        image_contents=($(chroot /host /bin/bash -c "${ctr_command} content ls" | grep "${formatted_image}" | awk '{print $1}'))
        if [ "${#image_contents[@]}" -gt 0 ]; then
                for content in $image_contents; do
                        chroot /host /bin/bash -c "${ctr_command} content rm "$content""
                done
        fi
done
echo "::endgroup::"
