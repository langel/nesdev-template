#!/bin/bash
onchange -v -p 250 './*.asm' './src/*.asm' './objs/*.asm' -- sh -c 'echo compiling && dasm new_name.asm -Isrc -Iaudio -Ivisual -orom.nes -f3 -v2 -llisting.txt && echo launching && cmd.exe /C start rom.nes'
# dasm -sromsym.txt will export symbol file
