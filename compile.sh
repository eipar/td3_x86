#!/bin/bash

###Script de Compilacion para TD3

mkdir -p bin
mkdir -p doc

#Borro cosas anteriores, tanto binarios como elfs
rm ./sup/*.elf
rm ./bin/*.bin

#Compilo todo
for fname in ./src/*
do
	if [[ $fname == *.s ]]
	then
		nasm -I inc/ -f elf32 ./src/"$(basename $fname)" -o ./sup/"$(basename -s .s $fname)".elf
	fi
	if [[ $fname == *.c ]]
	then
		gcc -c -m32 -fno-stack-protector -fno-asynchronous-unwind-tables -Wall ./src/"$(basename $fname)" -o ./sup/"$(basename -s .c $fname)".elf
	fi
done

#linkeo
ld -z max-page-size=0x01000 -T ./sup/linker.ld --oformat=binary -m elf_i386 -e start16 ./sup/*.elf -o ./bin/bios.bin -Map ./sup/bios.map
