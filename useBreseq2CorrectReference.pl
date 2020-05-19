use FileUtil;

my $fasta = shift;
my $breseq = shift;

my $ffh = FileUtil::openFileHandle("perl ./reformatFasta.pl $fasta 0 9999999999|");
while (<$ffh>) {
	if (/^>(\S+)/) {
		my $id = $1;
		$_ = <$ffh>;
		chomp;
		my @s = split //,$_;
		$seq{$id} = \@s;
	}
}
$ffh->close();

my $bfh = FileUtil::openFileHandle("sort -k 4,4 -k 5,5nr $breseq|");
while (<$bfh>) {
	next if /consensus_reject=/;
	chomp;
	my @d = split /\t/;
	if ($d[0] eq "INS") {
		my $pos = $d[4] - 1;
		${$seq{$d[3]}}[$pos] .= $d[5];
	} elsif ($d[0] eq "DEL") {
		my $pos = $d[4] - 1;
		${$seq{$d[3]}}[$pos] = "";
	} elsif ($d[0] eq "SNP") {
		my $pos = $d[4] - 1;
		${$seq{$d[3]}}[$pos] = $d[5];
	} elsif ($d[0] eq "SUB") {
		for (my $i = 0; $i < $d[5]; $i++) {
			my $pos = $d[4] - 1 + $i;
			${$seq{$d[3]}}[$pos] = "";
		}
		my $pos = $d[4] - 1;
		${$seq{$d[3]}}[$pos] = $d[6];
	}
}
$bfh->close();

foreach my $i (sort keys %seq) {
	print ">$i\n";
	my $l = join "",@{$seq{$i}};
	print $l,"\n";
}
