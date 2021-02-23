rule meRanT:
    input:
        rules.trimgalore.output
    output:
        bam = "results/bam/{sample}_sorted.bam"
    log:
        "logs/meRanT/{sample}.log"
    threads: max_threads
    params:
        id2gene = config['meRanT']['id2gene'],
        bsidx = config['meRanT']['bsidx']
    shell:
        'meRanT align '
        '-fastqF {input[0]} '
        '-fastqR {input[1]} '
        '-sam {wildcards.sample}.sam '
        '-outdir results/bam/ '
        '-id2gene {params.id2gene} '
        '-bsidx {params.bsidx} '
        '-deleteSAM '
        '-threads {threads} 2>&1 | tee {log}'