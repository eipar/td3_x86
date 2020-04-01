#!/bin/bash

#nasm ./src/*.s -o ./bin/mi_bios.bin

/opt/bochs-2.6.9-int/bin/bochs -f ./sup/.bochsrc -q
