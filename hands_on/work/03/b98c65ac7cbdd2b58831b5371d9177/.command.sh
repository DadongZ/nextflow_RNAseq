#!/bin/bash -ue
fastqc --threads 2 gut_1.fq gut_2.fq -o gut
