#!/bin/bash

count=$(ls -1q exports/ | wc -l)
padding_length=4
padded_count=$(printf "%0${padding_length}d" "$count")
new_name="new_name__$padded_count.nes"	
	
echo $new_name 
cp new_name.nes exports/$new_name
