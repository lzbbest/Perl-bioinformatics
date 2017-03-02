#! /usr/bin/perl -w
use strict;

#the script will combind multiLines to one line for each sequence.

#usage
if (@ARGV != 3) { die "Usage: perl $0 <id_file> <input_seq.fa> <outfile.fa> <unmapped>\n
The output file format would be
                mRNA_ID        Genename        Seq_len
                Formatted_Fasta_Sequences\n";
exit;
}

#code
open(ID,"$ARGV[0]") || die "cannot open $ARGV[0]\n";
open(OUT,">>$ARGV[2]") || die "cannot make $ARGV[2]\n";
open(UNMAPPED,">>$ARGV[3]") || die "cannot make $ARGV[3]\n";

while(my $id=<ID>){
      $id=~s/[\r\n]$//g;
      my $flag=1;
      open(FASTA,"$ARGV[1]") || die "cannot open $ARGV[1]\n";
      while(my $seq_id=<FASTA>){
            if($seq_id=~m/$id/){
                print OUT "$seq_id";
                my $seq=<FASTA>;
                print OUT "$seq";
                $flag=0;
                last;
            }
      }
      close FASTA;
      if($flag){
          print UNMAPPED "$id\n";
      }
}

close ID;
close OUT;
close UNMAPPED;