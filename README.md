# containerd-image-cleanup

Debug container image to delete images in containerd for kata-containers and CoCo CI testing

Based on [kata-debug](https://github.com/kata-containers/kata-containers/tree/main/tools/packaging/kata-debug)

## Using

Run
```
kubectl debug node/<NODE_NAME> --image=quay.io/stevenhorsman/containerd-image-cleanup:latest
```
This will remove the image and content for some selected container images used in kata testing, so that the nydus-snapshotter can be triggered correctly.

To see the list of matching images that were found and removed you can check the logs of the pod that ran:
```
kubectl logs pod/node-debugger...
```

Once finished, don't forgot to delete the debug pod to clean up.

## Building and pushing

To build first run:
```
docker buildx create --name mybuilder --bootstrap --use
```
to create a new builder. Next run:
```
REGISTRY=<your_registry> TAG=<your_tag> build-and-upload-payload.sh
```
to build and upload the image.
