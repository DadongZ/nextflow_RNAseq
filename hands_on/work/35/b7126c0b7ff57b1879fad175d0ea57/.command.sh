#!/bin/bash -ue
fastqc --threads 2 -f fastq -q liver_1.fq liver_2.fq -o fastqc_liver_log
