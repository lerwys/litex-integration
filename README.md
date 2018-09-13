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

## Usage

The idea of this project is to be used as a template to work with
Litex environment tools in a reproducible way. So, basically,
one would have all of the litex project sources inside `litex-intergration`
directory and the result of that would be generated at the `build`
directory, available in the host machine after the container finishes.

Everything inside `litex-intergration` directory will be bind mounted
to the `/litex-intergration` inside the cointainer. The developer can
then run the desired command when running the container.

As an example, the Makefile contains the necessary `docker-compose`
flags to run the litex environment, bind mount the directories
and run the base_cpu.oy litex python command to generate all of the
gaetware and software.

## Build example project

Be sure to clone this repository with: `--recursive` or `--recurse-submodules`:

```bash
    git clone --recurse-submodules https://github.com/lerwys/litex-intergration
```

Build example project:

```bash
    make run
```

The results will be at `build` directory. The Makefile basically contains
docker-compose commands with the appropriate flags .

To remove the generated files, run:

```bash
    make clean
```
