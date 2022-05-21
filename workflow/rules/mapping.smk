rule meRanT:
    input:
        r1_filtered_fq = rules.trimgalore.output.r1_filtered_fq,
        r2_filtered_fq = rules.trimgalore.output.r2_filtered_fq,
        bsidx = rules.make_transcript_fa_bsidx.output.transcripts_fa_C2T,
        id2gene = rules.make_id2gene.output.id2_gene
    output:
        bam = "results/bam/{sample}_sorted.bam"
    log:
        "logs/meRanT/{sample}.log"
    threads: max_threads
    shell:
        'meRanT align '
        '-id2gene {input.id2gene} '
        '-bsidx {input.bsidx} '
        '-threads {threads} '
        '-deleteSAM '
        '-fastqF {input.r1_filtered_fq} '
        '-fastqR {input.r2_filtered_fq} '
        '-outdir results/bam/ '
        '-sam {wildcards.sample}.sam 2>&1 {log}'
