#!/bin/bash -ue
mkdir fastqc_gut_logs
fastqc --threads 2 -o fastqc_gut_logs -f fastq -q gut_1.fq gut_2.fq
