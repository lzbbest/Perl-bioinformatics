#!/usr/bin/perl   -w
use strict;

if (@ARGV != 3) { die "Usage: perl $0 <map> <outfile>\n";}

#code
open(SEQ,"$ARGV[0]") || die "cannot open $ARGV[0]\n";
open(OUT1,">>$ARGV[1]") || die "cannot make $ARGV[1]\n";  #输出蛋白质序列
open(OUT2,">>$ARGV[2]") || die "cannot make $ARGV[2]\n";  #输出不合格的DNA序列名称

$/=">";
<SEQ>;
my $j=0;
while(my $seq=<SEQ>) {
      $seq=~s/(^.+\n)//;
      my $gene=">";
      $gene.=$1;
      #print "$1$seq\n";
      $seq = uc $seq;#将所有的小写转化为大写
      chomp $seq;
      my $protein="";
      unless($seq=~m/^ATG/){print OUT2 "$gene";next;}         #起始密码子终止密码子不合格的剔除
      unless($seq=~m/TAA$|TAG$|TGA$/){print OUT2 "$gene";next;}
      for(my $i=0;$i<(length($seq)-2);$i+=3){
          my $codon=substr($seq,$i,3);
          $protein.=codon_aa($codon);
          if(codon_aa($codon) eq "_"){ #遇到中止密码子停止翻译
             last;
          }}
      $protein=~s/\_//;
      print OUT1 "$gene$protein\n";   #输出合格氨基酸
}
sub codon_aa{ #将密码子转化为氨基酸
    my($codon)= @_;
    my(%genetic_code) = (
    'TCA' => 'S',    # Serine
    'TCC' => 'S',    # Serine
    'TCG' => 'S',    # Serine
    'TCT' => 'S',    # Serine
    'TTC' => 'F',    # Phenylalanine
    'TTT' => 'F',    # Phenylalanine
    'TTA' => 'L',    # Leucine
    'TTG' => 'L',    # Leucine
    'TAC' => 'Y',    # Tyrosine
    'TAT' => 'Y',    # Tyrosine
    'TAA' => '_',    # Stop
    'TAG' => '_',    # Stop
    'TGC' => 'C',    # Cysteine
    'TGT' => 'C',    # Cysteine
    'TGA' => '_',    # Stop
    'TGG' => 'W',    # Tryptophan
    'CTA' => 'L',    # Leucine
    'CTC' => 'L',    # Leucine
    'CTG' => 'L',    # Leucine
    'CTT' => 'L',    # Leucine
    'CCA' => 'P',    # Proline
    'CCC' => 'P',    # Proline
    'CCG' => 'P',    # Proline
    'CCT' => 'P',    # Proline
    'CAC' => 'H',    # Histidine
    'CAT' => 'H',    # Histidine
    'CAA' => 'Q',    # Glutamine
    'CAG' => 'Q',    # Glutamine
    'CGA' => 'R',    # Arginine
    'CGC' => 'R',    # Arginine
    'CGG' => 'R',    # Arginine
    'CGT' => 'R',    # Arginine
    'ATA' => 'I',    # Isoleucine
    'ATC' => 'I',    # Isoleucine
    'ATT' => 'I',    # Isoleucine
    'ATG' => 'M',    # Methionine
    'ACA' => 'T',    # Threonine
    'ACC' => 'T',    # Threonine
    'ACG' => 'T',    # Threonine
    'ACT' => 'T',    # Threonine
    'AAC' => 'N',    # Asparagine
    'AAT' => 'N',    # Asparagine
    'AAA' => 'K',    # Lysine
    'AAG' => 'K',    # Lysine
    'AGC' => 'S',    # Serine
    'AGT' => 'S',    # Serine
    'AGA' => 'R',    # Arginine
    'AGG' => 'R',    # Arginine
    'GTA' => 'V',    # Valine
    'GTC' => 'V',    # Valine
    'GTG' => 'V',    # Valine
    'GTT' => 'V',    # Valine
    'GCA' => 'A',    # Alanine
    'GCC' => 'A',    # Alanine
    'GCG' => 'A',    # Alanine
    'GCT' => 'A',    # Alanine
    'GAC' => 'D',    # Aspartic Acid
    'GAT' => 'D',    # Aspartic Acid
    'GAA' => 'E',    # Glutamic Acid
    'GAG' => 'E',    # Glutamic Acid
    'GGA' => 'G',    # Glycine
    'GGC' => 'G',    # Glycine
    'GGG' => 'G',    # Glycine
    'GGT' => 'G',    # Glycine
    );
    if(exists $genetic_code{$codon}){
        return $genetic_code{$codon};
    }
    else{
         print "Bad codon \"$codon\"!!\n";
    }
}
close SEQ;
close OUT1;
close OUT2;