#!/usr/bin/env python3

import argparse
import glob
import logging
import os

import pandas as pd

def main(args):

    # Setup logging and print args
    logging.basicConfig(format='%(asctime)s %(levelname)s : %(message)s', level=logging.INFO)
    logging.info("Will include samples from the following dirs: {dirs}".format(dirs=",".join(args.sample_dirs)))
    logging.info("Read1 extension: {read1}".format(read1=args.read1_extension))
    logging.info("Read2 extension: {read2}".format(read2=args.read2_extension))

    # Setup vars
    metadata = dict()
    read_info = dict()
    read_info['r1'] = args.read1_extension
    read_info['r2'] = args.read2_extension

    # Get files ending with extensions for each given dir
    for sample_dir in args.sample_dirs:
        for read_type in read_info.keys():
            files = glob.glob(sample_dir + '/**/*' + read_info[read_type], recursive=True)
            for file in files:
                sample = os.path.basename(os.path.dirname(file))
                metadata.setdefault(sample, {})
                logging.info("Will include {file} for "
                             "{sample}-{read_type}".format(file=file,sample=sample, read_type=read_type))
                metadata[sample][read_type] = file

    # Convert to df
    metadata_df = pd.DataFrame(metadata).transpose()

    # Add empty cols for Condition.
    # This is done to ensure naming consistency
    metadata_df['condition'] = ""
 
    # Write metadata file
    metadata_df.to_csv(args.outfile, sep="\t", index_label="sample")


if __name__ == "__main__":

    # Process command line args
    parser = argparse.ArgumentParser(description="Script to generate metadata.tsv")
    parser.add_argument('-d', '--dirs', dest='sample_dirs', action='append')
    parser.add_argument('-f', '--read1', dest='read1_extension')
    parser.add_argument('-r', '--read2', dest='read2_extension')
    parser.add_argument('-o', '--outfile', dest='outfile', default = "config/samples.tsv")
    cmd_args = parser.parse_args()
    main(cmd_args)
