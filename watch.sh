#!/bin/bash
onchange -v -p 250 './*.asm' './src/*.asm' './objs/*.asm' -- sh -c 'echo compiling && dasm new_name.asm -Isrc -Iaudio -Ivisual -onew_name.nes -f3 -v2 -llisting.txt && echo launching && cmd.exe /C start new_name.nes'
# dasm -sromsym.txt will export symbol file
