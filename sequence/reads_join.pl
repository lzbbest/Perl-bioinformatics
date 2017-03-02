#!/usr/bin/perl -w
use strict;

unless(@ARGV==3)
{ die "Usage: perl $0 <input.fa> <out.len>\n";
}

my($infile,$outfile1,$outfile2)=@ARGV;

open IN,"<$infile" || die "error: cannot open th infile:$infile\n";
open OUT1,">$outfile1" || die " error: cannot make th outfile1:$outfile1\n";
open OUT2,">$outfile2" || die " error: cannot make th outfile2:$outfile2\n";

$/=">";<IN>;                                                    # 设置输入记录分隔符为”>”，并去除第一个”>”
my ($id,$name);
while ( my $seq = <IN>){
            if($seq=~m/^\S+\s(.+)/)                            # 得到序列名
            {
                    $name=$1;
            }
            chomp $seq;                                        # 去掉末尾的”>”
            $seq =~ s/^.+\n//;                                 # 删除序列编号所在的行，即第一行
            $seq =~ s/\s//g;                                   # 删除序列中的空白字符
            my $lenSEQ=length($seq);
            my $lenALL=0;
            my $readNum;
            for(my $j=0;$j<85;$j++){
              #(@fragment,@single)=&break($seq);
              my ($subs,$subr)=break($seq);
              my @fragment=@$subs;
              my @single=@$subr;
              print OUT1 ">NO.$j\t$name\n$seq\n";
              foreach (@fragment){
              print OUT1 "$_\n"; }
#               for(my $i=0;$i<scalar(@fragment);$i++){
#                   $single[$i]=substr($fragment[$i],0,int(rand(50))+50);
#                   print OUT2 "$single[$i]\n";}
               #print OUT2 ">NO.$j\t$lenSEQ\t$name\n";
              foreach (@single){
                      my $len=length($_);
                      print OUT2 ">$len\n$_\n";
                      $lenALL+=$len;}
              $readNum+= scalar(@single);
            }
            my $m=$lenALL/$lenSEQ;
            print OUT2 "$lenALL\tm=$m";
            print "seq:$lenSEQ\tread:$lenALL\treadNum:$readNum\tm=$m";
}
$/="\n";
close IN;
close OUT1;
close OUT2;


sub break{                            #input seq  only
    my $seq=$_[0];
    my $length=length($seq);
    my $breakPointNumber=$length/1000;
    my @random=createRandNum($length,$breakPointNumber);
    @random=sort{$a<=>$b}@random;
    my @seqFragment;
    $seqFragment[0]=substr($seq,0,$random[0]);
    for (my $i=1;$i<scalar(@random);$i++){
         $seqFragment[$i]=substr($seq,$random[$i-1],$random[$i]-$random[$i-1]);
    }
    my @fragment=grep(length($_)>200 && length($_)<1500,@seqFragment);      #select fragment which length is between 400-1200
     my @single;
     for(my $i=0;$i<scalar(@fragment);$i++){
         $single[$i]=substr($fragment[$i],0,int(rand(100))+150);}               #select single terminal fragment which length is between 50-100
    return     (\@fragment,\@single);
}
sub createRandNum                     #no repeat random
{
    my ($MaxNum,$MaxCount) = @_;
    my $no;
    my $i = 0;
    my %rand = ();
    while (1)
    {
        $no = int(rand($MaxNum));
        if (!$rand{$no})
        {
            $rand{$no} = 1;
            $i++;
        }
        last if ($i >= $MaxCount);
    }
    my @randnum = keys % rand;
    return @randnum;
}