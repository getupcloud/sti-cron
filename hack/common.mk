SKIP_SQUASH?=0

build = hack/build.sh

OS := centos7

script_env = \
	SKIP_SQUASH=$(SKIP_SQUASH)                      \
	VERSIONS="$(VERSIONS)"                          \
	OS=$(OS)                                        \
	VERSION=$(VERSION)                              \
	BASE_IMAGE_NAME=$(BASE_IMAGE_NAME)

.PHONY: build
build:
	$(script_env) $(build)
