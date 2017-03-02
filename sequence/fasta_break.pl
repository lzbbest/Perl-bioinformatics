#!/usr/bin/perl -w
use strict;

unless(@ARGV==2)
{ die "Usage: perl $0 <input.fa> <out.len>\n";
}

my($infile,$outfile)=@ARGV;

open IN,"<$infile" || die "error: cannot open th infile:$infile\n";
open OUT,">>$outfile" || die " error: cannot make th outfile:$outfile\n";

 $/=">";<IN>;                       # ���������¼�ָ���Ϊ��>������ȥ����һ����>��
#for(my $j=0;$j<3;$j++){
    my ($id,$name);
    while ( my $seq = <IN>){
            if($seq=~m/^\S+\s(.+)/)                    # �õ�������
            {
                    $name=$1;
            }
            chomp $seq;                                        # ȥ��ĩβ�ġ�>��
            $seq =~ s/^.+\n//;                                    # ɾ�����б�����ڵ��У�����һ��
            $seq =~ s/\s//g;                                # ɾ�������еĿհ��ַ�
            for(my $j=0;$j<3;$j++){
              my @fragment=break($seq);
              print OUT ">NO.$j\t$name\n$seq\n"; 
              foreach (@fragment){
              print OUT "$_\n"; }
    }
}
$/="\n";
close IN;
close OUT;


sub break{
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
    my @result=grep(length($_)>400 && length($_)<1200,@seqFragment);      #select fragment which length is between 400-1200
    return     @result;
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