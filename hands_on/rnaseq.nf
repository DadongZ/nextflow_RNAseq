
/*
 * pipeline input parameters
 */
baseDir="/mounts/isilon/data/eahome/u1072932/resource/nextflow"
params.reads = "$baseDir/nf-training/data/ggal/*_{1,2}.fq"
params.transcriptome = "$baseDir/nf-training/data/ggal/transcriptome.fa"
params.multiqc = "~/anaconda3/envs/nextflow/bin/multiqc"
params.outdir = "$baseDir/hands_on/rnaseq_output"

log.info """\
         R N A S E Q - N F   P I P E L I N E    
         ===================================
         transcriptome: ${params.transcriptome}
         reads        : ${params.reads}
         outdir       : ${params.outdir}
         """
         .stripIndent()

/*
 * define the `index` process that create a binary index
 * given the transcriptome file
 */
process index {
    cpus 2

    input:
    path transcriptome from params.transcriptome

    output:
    path 'index' into index_ch

    script:
    """
    salmon index --threads $task.cpus -t $transcriptome -i index
    """
}

Channel
    .fromFilePairs(params.reads, checkIfExists: true)
    //.set{ read_pairs_ch }
    .into { read_pairs_ch; read_pairs_ch2 }

process quantification {
    
    tag "$sample_id"
    publishDir "$params.outdir/quant"
    
    cpus 4

    input:
    path index from index_ch
    tuple sample_id, path(reads) from read_pairs_ch

    output:
    path sample_id into quant_ch

    script:
    """
    salmon quant --threads $task.cpus --libType=U -i $index -1 ${reads[0]} -2 ${reads[1]} -o $sample_id
    """
}

process fastqc {
    tag "FastqQC of $sample_id"
    publishDir "$params.outdir/fastqc"

    cpus 2

    input:
    tuple sample_id, path(reads) from read_pairs_ch2

    output:
    path "fastqc_${sample_id}_logs" into fastqc_ch

    script:
    """
    mkdir fastqc_${sample_id}_logs
    fastqc --threads $task.cpus -o fastqc_${sample_id}_logs -f fastq -q ${reads}
    """
}

process multiqc {
    tag "Multiqc"
    publishDir "$params.outdir/multiqc"

    input:
    path '*' from quant_ch.mix(fastqc_ch).collect()

    output:
    path 'multiqc_report.html'

    script:
    """
    multiqc .
    """
}

workflow.onComplete {
    log.info (workflow.success ? "\nDone! Open the following report in your browser -->$params.outdir/multiqc/multiqc_report.html \n" : "Oops .. something went wrong")
}
