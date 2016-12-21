#!/bin/bash
cd /home/miles/smartsynth/

echo '-------------------------------------------------' >> logs/log.autostart
date | sed "s/$/ autostart/g" >> logs/log.autostart
whoami | sed "s/$/ logged/g" >> logs/log.autostart

jupyter nbconvert --to notebook --execute --inplace  main.ipynb
jupyter-notebook --ip=*

