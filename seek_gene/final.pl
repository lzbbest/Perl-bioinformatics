#! /usr/bin/perl -w
use strict;

#the script will combind multiLines to one line for each sequence.

#usage
if (@ARGV != 4) { die "Usage: perl $0 <id_file> <input_seq.fa> <outfile.fa> <unmapped>\n
The output file format would be
                mRNA_ID        Genename        Seq_len
                Formatted_Fasta_Sequences\n";
exit;
}

my ($id_file,$input_seq,$outfile,$unmapped)=@ARGV;

system "perl 1_Combind_Lines_For_Fasta_1.pl $input_seq temp";
system "perl 2_according_ID.pl $id_file temp $outfile $unmapped";
system ("del temp");