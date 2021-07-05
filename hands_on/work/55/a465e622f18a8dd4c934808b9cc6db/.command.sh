#!/bin/bash -ue
salmon quant --threads 4 --libType=U -i index -1 liver_1.fq -2 liver_2.fq -o liver
