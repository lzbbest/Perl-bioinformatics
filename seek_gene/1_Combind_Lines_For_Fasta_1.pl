#! /usr/bin/perl -w
use strict;

#the script will combind multiLines to one line for each sequence.

#usage
if (@ARGV != 2) { die "Usage: perl $0 <infile.fa> <outfile.fa>\n
The output file format would be
                mRNA_ID        Genename        Seq_len
                Formatted_Fasta_Sequences\n";
exit;
}

#code
##read in a fasta file
open(FASTA,"$ARGV[0]") || die "cannot open $ARGV[0]\n";
open(OUT,">>$ARGV[1]") || die "cannot make $ARGV[1]\n";

$/=">";<FASTA>;                                                                                                        # 设置输入记录分隔符为”>”，并去除第一个”>”

my ($id,$name);

while ( my $seq = <FASTA>){
        if($seq=~m/^(\S+).*\((.*)\)/)           # 得到序列ID和基因名
        {
                $id=$1;
                $name=$2;
        }
        chomp $seq;                # 去掉末尾的”>”
    $seq =~ s/^.+\n//;        # 删除序列编号所在的行，即第一行
        $seq =~ s/\s//g;        # 删除序列中的空白字符
    my $len = length($seq);                       # 计算序列长度
    print OUT ">$id\t$name\t$len\n";        # 输出结果到输出文件
        print OUT "$seq\n";
}

$/="\n";

close FASTA;
close OUT;