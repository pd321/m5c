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
        get_fastqs
    output:
        temp(["results/bam/{sample}_val_1.fq.gz", "results/bam/{sample}_val_2.fq.gz"])
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
        '{input[0]} {input[1]} 2>&1 | tee {log}'