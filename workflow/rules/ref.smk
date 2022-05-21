rule get_transcript_fa:
    output: 
        transcripts_fa = "data/external/ref/fa/transcripts.fa"
    log: "logs/ref/get_transcript_fa.log"
    params:
        transcript_fa_url = config['meRanT']['index']['transcript_fa_url']
    shell:
        'wget -O {output} {params.transcript_fa_url} 2> {log}'

rule make_transcript_fa_bsidx:
    input: rules.get_transcript_fa.output.transcripts_fa
    output: 
        transcripts_fa_C2T = "data/external/ref/idx/meranT/transcripts_C2T.fa"
    threads: threads_mid
    log: "logs/ref/meRanT/bsidx.log"
    shell:
        'meRanT mkbsidx '
        '-fasta {input} '
        '-bsidxdir data/external/ref/idx/meranT '
        '-threads {threads} 2> {log}'

rule make_id2gene:
    input: rules.get_transcript_fa.output.transcripts_fa
    output: 
        id2_gene = "data/external/ref/misc/transcript_name_to_gene.map"
    shell:
        'grep -P "^>" {input}|'
        'perl -p -e \'s/^>///\'|'
        'awk -F "|" \'{{print $0,$6,$7}}\' OFS="\\t" > {output}'

