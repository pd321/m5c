from snakemake.utils import validate,available_cpu_count
import pandas as pd

##### load config and sample sheets #####

configfile: "config/config.yaml"
validate(config, schema="../schemas/config.schema.yaml")

samples = pd.read_csv(config["samples"], sep="\t").set_index("sample", drop=False)
samples.index.names = ["sample_id"]
sample_names = samples.index.tolist()
validate(samples, schema="../schemas/samples.schema.yaml")

max_threads = config['threads']

def get_individual_fastq(wildcards):
    return samples.loc[(wildcards.sample),(wildcards.read)]

def get_fastqs(wildcards):
    return samples.loc[(wildcards.sample), ["r1", "r2"]]