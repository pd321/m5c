rule fastqc:
	input:
		get_individual_fastq
	output:
		html="results/qc/fastqc/{sample}.{read}_fastqc.html",
		zip="results/qc/fastqc/{sample}.{read}_fastqc.zip"
	log:
        "logs/fastqc/{sample}.{read}.log" 
	wrapper:
		"0.72.0/bio/fastqc"

rule trim_galore:
    input:
        get_fastqs
    output:
        r1_trimmed=temp("results/qc/trimming/{sample}.1_val_1.fq.gz"),
        r1_trim_report="results/qc/trimming/{sample}.1.fastq.gz_trimming_report.txt",
        r2_trimmed=temp("results/qc/trimming/{sample}.2_val_2.fq.gz"),
        r2_trim_report="results/qc/trimming/{sample}.2.fastq.gz_trimming_report.txt"
    log:
        "logs/trim_galore/{sample}.log"
    threads: max_threads
    wrapper:
        "0.72.0/bio/trim_galore/pe"