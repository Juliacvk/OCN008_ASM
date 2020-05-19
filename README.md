# OCN008_ASM

Assumes that these files are in the same directory.
This script is meant to be used iteratively. Each iteration should increase the quality of the genome.
This will only correct for small SNPs and INDELs that are often associated with nanopore assemblies.
The number of cycles needed will vary - there is a possibility that cycles will occur in which case independent assessment of the data will have to be done to break the cycle.

#start
breseq -r genome.fasta trimmed/read1.paired.trimmed.fastq trimmed/read2.paired.trimmed.fastq -o breseq1
perl useBreseq2CorrectReference.pl genome.fasta breseq1/output/output.gd > corrected1.fasta
#iteration 2
breseq -r corrected1.fasta trimmed/read1.paired.trimmed.fastq trimmed/read2.paired.trimmed.fastq -o breseq2
perl useBreseq2CorrectReference.pl corrected1.fasta breseq2/output/output.gd > corrected2.fasta
#iteration 3
breseq -r corrected2.fasta trimmed/read1.paired.trimmed.fastq trimmed/read2.paired.trimmed.fastq -o breseq3
perl useBreseq2CorrectReference.pl corrected2.fasta breseq3/output/output.gd > corrected3.fasta
