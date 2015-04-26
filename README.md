gff2gtf
=======

AWK script for conversion of GFF files to GTF.

USAGE:

awk -f gff2gtf.awk FILE.gff > FILE.gtf

Works with those operating systems which have AWK interpreter. 
The script relies on order of records. Ordering is not required for GFF according to the specification, but usually records are ordered.

For RSEM:

awk -f gff2gtf-strict.awk FILE.gff > FILE.gtf
grep -Ev "\sgene\s" FILE.gtf > rsem-ready.gtf

Tags: *NGS, next-generation sequencing, genetics, fasta, DNA, RNA, alignment, genome markup.*
