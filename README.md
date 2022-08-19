# docker-xilinx

## how to build

- Copy the xillinx installer file (for example Xilinx_Unified_2022.1_0420_0327_Lin64.bin) to this folder.  
Then run ./docker-xilinx.sh
The builder will ask you for a valid xilinx account (email and password). It is checked at the installation.0

## how to run

run `./docker-xilinx.sh run <version>` for example run `./docker-xilinx.sh run 2022.1` tu run the previously built `vivado:2022.1` image

## Planed features

For now, you can only install Vivado with this repo, I plan to cover all the available products:

1. Vitis
2. Vivado
3. On-Premises Install for Cloud Deployments
4. BootGen
5. Lab Edition
6. Hardware Server
7. PetaLinux
8. Documentation Navigator (Standalone)