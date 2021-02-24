rule meRanCall:
    input:
        rules.meRanT.output.bam
    output:
        "results/calls/{sample}.txt"
    log:
        "logs/meRanCall/{sample}.log"
    conda:
        "../envs/merantk.yaml"
    threads: max_threads
    params:
        transcript_fasta = config['meRanCall']['transcript_fasta']
    shell:
        'meRanCall '
        '-sam {input} '
        '-result {output} '
        '-fasta {params.transcript_fasta} '
        '-transcriptDBref '
        '-procs {threads}'