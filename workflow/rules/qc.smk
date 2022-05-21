rule fastqc:
    input:
        get_individual_fastq
    output:
        html="results/qc/fastqc/{sample}.{read}_fastqc.html",
        zip="results/qc/fastqc/{sample}.{read}_fastqc.zip"
    log:
        "logs/fastqc/{sample}.{read}.log"
    threads: max_threads/2 
    wrapper:
        "0.72.0/bio/fastqc"

rule trimgalore:
    input:
        r1_raw_fq = lambda wildcards: get_fastqs(wildcards, "r1"),
        r2_raw_fq = lambda wildcards: get_fastqs(wildcards, "r2")
    output:
        r1_filtered_fq = temp("results/bam/{sample}_val_1.fq.gz"),
        r2_filtered_fq = temp("results/bam/{sample}_val_2.fq.gz")
    log:
        "logs/trimgalore/{sample}.log"
    conda:
        "../envs/trimgalore.yaml"
    threads: 4 if max_threads > 4 else max_threads
    shell:
        'trim_galore '
        '--gzip '
        '--output_dir results/bam/ '
        '--cores {threads} '
        '--basename {wildcards.sample} '
        '--paired --no_report_file '
        '{input.r1_raw_fq} {input.r2_raw_fq} 2>&1 {log}'
