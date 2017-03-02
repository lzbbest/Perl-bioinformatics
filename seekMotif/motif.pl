#! /usr/bin/perl -w
use strict;

#the script will combind multiLines to one line for each sequence.

#usage
if (@ARGV != 3) { die "Usage: perl $0 <coordinate> <chr19> <outfile>\n";}

#code
open(ID,"$ARGV[0]") || die "cannot open $ARGV[0]\n";
open(SEQ,"$ARGV[1]") || die "cannot make $ARGV[1]\n";
open(OUT,">>$ARGV[2]") || die "cannot make $ARGV[2]\n";

<SEQ>;
my $seq="";
my $tempseq;
 while($tempseq=<SEQ>){
       chomp $tempseq;
       $seq.=$tempseq;
}

open(ID,"$ARGV[0]") || die "cannot open $ARGV[0]\n";
while(my $str=<ID>){
       chomp $str;
       my @title=split /\t/,$str;
       if($title[2]=~m/chr19/x){
            if($title[3]=~m/\+/x){
                my $promoter=substr($seq,$title[4]-10001,10000);
                my $promoter_1=uc($promoter);
                my $where=0;
                my $result = index($promoter_1, "TTCATTCATTCA", $where);
                if($result != -1){
                    while ($result != -1) {
                      my $position_1=10000-$result-1;
                      print OUT "$title[1]\tFound motifs at $result\t";
                      $where = $result + 1;
                      $result = index($promoter_1, "TTCATTCATTCA", $where);
                    }
                    print OUT "\n";
                }
                #else{
                #print OUT "$title[1]\tNot exist modifs\n";}
            }
            else{
                 my $promoter_2=substr($seq,$title[5],10000);
                 my $promoter_3=&ReverseSeq($promoter_2);
                 my $where_2=0;
                 my $result_2 = index($promoter_3, "TTCATTCATTCA", $where_2);
                 if($result_2 != -1){
                    while ($result_2 != -1) {
                    my $position_2=10000-$result_2-1;
                    print OUT "$title[1]\tFound motifs at $result_2\t";
                    $where_2 = $result_2 + 1;
                    $result_2 = index($promoter_3, "TTCATTCATTCA", $where_2);
                    }
                    print OUT "\n";
                }
            }
       }
}

sub ReverseSeq(){
    my $sequence=$_[0];
    $sequence=~tr/atcgATCG/tagcTAGC/;
    return     reverse uc($sequence);
}
close ID;
close SEQ;
close OUT;