#!/bin/bash
echo compiling && dasm new_name.asm -Isrc -Iaudio -Ivisual -onew_name.nes -f3 -v2 -llisting.txt
# dasm -sromsym.txt will export symbol file
