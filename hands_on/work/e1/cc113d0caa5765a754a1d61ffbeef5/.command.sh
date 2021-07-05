#!/bin/bash -ue
mkdir fastqc_liver_logs
fastqc --threads 2 -o fastqc_liver_logs -f fastq -q liver_1.fq liver_2.fq
