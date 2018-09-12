Litex Example integration project in a container
===============================

Overview
--------

This image contains the necessary files for running
Litex integration.

For now the litex project is heavilly based on the yetifrisstlama
github repository called `litex_test_project` available here:
https://github.com/yetifrisstlama/litex_test_project

## Prerequisites

You must have the following installed in yout base system:

    - docker >= 17.09.0
    - docker-compose >= 1.17.0
    - Xilinx Vivado 2018.2 installed in /opt/Xilinx

## Build example project

Be sure to clone this repository with: `--recursive` or `--recurse-submodules`:

```bash
    git clone --recurse-submodules https://github.com/lerwys/litex-intergration
```

Build example project:

```bash
    docker-compose -f submodules/docker-litex-env-composed/docker-compose.yml run --rm -v "$PWD"/litex-integration:/litex-integration litex-env python3 /litex-integration/base_cpu.py build
```
