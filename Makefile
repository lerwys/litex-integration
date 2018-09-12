DOCKER_LITEX_ENV_COMPOSE_FILE=submodules/docker-litex-env-composed/docker-compose.yml
USER_ID=$(shell id -u ${USER})
# This is the home created inside the image
IMAGE_HOME=/home/user

.PHONY: run prepare-env clean

run: prepare-env
	docker-compose -f $(DOCKER_LITEX_ENV_COMPOSE_FILE) \
		run \
		--rm \
		-e LOCAL_USER_ID=$(USER_ID) \
		-v "${PWD}"/litex-integration:/litex-integration \
		-v "${PWD}"/build:/build \
		litex-env \
		python3 /litex-integration/base_cpu.py build

prepare-env:
	mkdir -p build

clean:
	rm -rf build
