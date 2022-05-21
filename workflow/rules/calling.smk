rule meRanCall:
    input:
        merant_bam = rules.meRanT.output.bam,
        transcript_fa = rules.get_transcript_fa.output.transcripts_fa
    output:
        "results/calls/{sample}.txt"
    log:
        "logs/meRanCall/{sample}.log"
    threads: max_threads
    params:
        seq_context_around_meth_c = config['meRanCall']['seq_context_around_meth_c'],
        min_methlyation_rate = config['meRanCall']['min_methlyation_rate']
    shell:
        'meRanCall '
        '-seqContext {params.seq_context_around_meth_c} '
        '-minMethR {params.min_methlyation_rate} '
        '-fasta {input.transcript_fa} '
        '-procs {threads} '
        '-transcriptDBref '
        '-bam {input.merant_bam} '
        '-result {output} 2>&1 {log}'
