DOCKER_LITEX_ENV_COMPOSE_FILE=submodules/docker-litex-env-composed/docker-compose.yml

.PHONY: run prepare-env clean

run: prepare-env
	docker-compose -f $(DOCKER_LITEX_ENV_COMPOSE_FILE) \
		run \
		--rm \
		-v "${PWD}"/litex-integration:/litex-integration \
		-v "${PWD}/build:/build" \
		litex-env \
		python3 /litex-integration/base_cpu.py build

prepare-env:
	mkdir build

clean:
	rm -rf build
