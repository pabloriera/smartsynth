#!/bin/bash

## Set the CPU scaling governor to performance
for gov in /sys/devices/system/cpu/cpu[0-9]*/cpufreq/scaling_governor; do echo "performance" | sudo tee $gov >/dev/null; done

sudo jackd --verbose -P70 -p16 -t2000 -d alsa -dhw:CODEC -p 256 -n 3 -r 44100 -s 