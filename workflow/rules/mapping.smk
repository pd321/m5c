rule meRanT:
    input:
        r1 = rules.trim_galore.output.r1_trimmed,
        r2 = rules.trim_galore.output.r2_trimmed
    output:
        bam = "results/bam/{sample}_sorted.bam",
        mbias_plot_fwd = "results/plots/mbias/{sample}_m-bias_fwd.png",
        mbias_plot_rev = "results/plots/mbias/{sample}_m-bias_rev.png"
    log:
        "logs/meRanT/{sample}.log"
    threads: max_threads
    params:
        id2gene = config['meRanT']['id2gene'],
        bsidx = config['meRanT']['bsidx']
    shell:
        'meRanT align '
        '-fastqF {input.r1} '
        '-fastqR {input.r1} '
        '-sam {wildcards.sample}.sam '
        '-outdir results/bam/ '
        '-id2gene {params.id2gene} '
        '-bsidx {params.bsidx} '
        '-mbiasplot '
        '-forceDir -deleteSAM '
        '-threads {threads} 2>&1 | tee {log}'