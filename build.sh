#!/usr/bin/env bash


# Abort on any error
set -e -u

# Simpler git usage, relative file paths
CWD=$(dirname "$0")
cd "$CWD"

# Load helpful functions
source libs/common.sh
source libs/docker.sh

# Check access to docker daemon
assert_dependency "docker"
if ! docker version &> /dev/null; then
	echo "Docker daemon is not running or you have unsufficient permissions!"
	exit -1
fi

IMG_NAME="hetsh/hornet"
case "${1-}" in
	# Build and test with default configuration
	"--test")
		docker build \
			--tag "$IMG_NAME:test" \
			.
		docker run \
			--rm \
			--tty \
			--interactive \
			--publish 8081:8081/tcp \
			--publish 14265:14265/tcp \
			--publish 14626:14626/udp \
			--publish 15600:15600/tcp \
			--mount type=bind,source=/etc/localtime,target=/etc/localtime,readonly \
			"$IMG_NAME:test"
	;;
	# Build if it does not exist and push image to docker hub
	"--upload")
		if ! tag_exists "$IMG_NAME"; then
			docker build \
				--tag "$IMG_NAME:latest" \
				--tag "$IMG_NAME:$_NEXT_VERSION" \
				.
			docker push "$IMG_NAME:latest"
			docker push "$IMG_NAME:$_NEXT_VERSION"
		fi
	;;
	# Build image without additonal steps
	*)
		docker build \
			--tag "$IMG_NAME:latest" \
			.
	;;
esac
