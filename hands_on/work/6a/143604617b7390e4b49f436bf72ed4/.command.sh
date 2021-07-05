#!/bin/bash -ue
fastqc --threads 2 lung_1.fq lung_2.fq -o fastqc_lung_logs -f fastq -q lung_1.fq lung_2.fq
