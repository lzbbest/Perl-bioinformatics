#!/usr/bin/perl -w
use strict; # Bookmarks: 0,0 0,0 0,0 0,0 40,30

#usage
if (@ARGV != 2) { die "Usage: perl $0 <sequence> <outfile>\n";}

#code
open(SEQ,"$ARGV[0]") || die "cannot make $ARGV[0]\n";
open(OUT,">>$ARGV[1]") || die "cannot make $ARGV[1]\n";

<SEQ>;
my $seq="";
my $tempseq;
 while($tempseq=<SEQ>){
       chomp $tempseq;
       $seq.=$tempseq;
}
my $seqlen=length($seq);
my $end=0;
for(my $strlen=6;$strlen<51;$strlen+=2){      #�������г���
    my $percent=$strlen/0.6;                   #�޶����Ľṹ�ı�������60%
    #ptint "process loop:$strlen...";
    for(my $j=$strlen;$j<$percent;$j++){       #���Ľṹ��󳤶ȣ������м䲻��������
      for(my $i=0;$i<$seqlen-$j;$i++){         #�ӵ�һ����bp��ʼѰ��
          my $str=substr($seq,$i,$j);
          my $str_1=&ReverseSeq($str);
          my $half=$strlen/2;
          my $loop1=substr($str,0,$half);
          my $loop2=substr($str_1,0,$half);
          if($loop1 eq $loop2){
              $end=$i+$strlen;
              my $gap_length=$j-$strlen;               #gap�滻��*
              my $gap=substr($str,$half,$gap_length);
              $gap=~tr/ATCG/****/;
              my $loop2_=&ReverseSeq($loop2);
              $str=$loop1.$gap.$loop2_;
              print OUT "start:$i\tend:$end\t$str\n";
          }
      }
    }
}

sub ReverseSeq(){            #���򻥲�
    my $sequence=$_[0];
    $sequence=~tr/ATCG/TAGC/;
    return     reverse $sequence;
}
close SEQ;
close OUT;