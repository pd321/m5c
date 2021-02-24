rule meRanT:
    input:
        r1_filtered_fq = rules.trimgalore.output.r1_filtered_fq,
        r2_filtered_fq = rules.trimgalore.output.r2_filtered_fq
    output:
        bam = "results/bam/{sample}_sorted.bam"
    log:
        "logs/meRanT/{sample}.log"
    conda:
        "../envs/merantk.yaml"
    threads: max_threads
    params:
        id2gene = config['meRanT']['id2gene'],
        bsidx = config['meRanT']['bsidx']
    shell:
        'meRanT align '
        '-fastqF {input.r1_filtered_fq} '
        '-fastqR {input.r2_filtered_fq} '
        '-sam {wildcards.sample}.sam '
        '-outdir results/bam/ '
        '-id2gene {params.id2gene} '
        '-bsidx {params.bsidx} '
        '-deleteSAM '
        '-threads {threads} 2>&1 | tee {log}'