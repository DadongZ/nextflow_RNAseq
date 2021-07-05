#!/bin/bash -ue
mkdir fastqc_lung_logs
fastqc --threads 2 -o fastqc_lung_logs -f fastq -q lung_1.fq lung_2.fq
