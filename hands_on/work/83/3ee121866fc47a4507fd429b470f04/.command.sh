#!/bin/bash -ue
fastqc --threads 2 lung_1.fq lung_2.fq -o lung
