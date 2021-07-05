#!/bin/bash -ue
fastqc --threads 2 gut_1.fq gut_2.fq -o fastqc_gut_logs -f fastq -q gut_1.fq gut_2.fq
