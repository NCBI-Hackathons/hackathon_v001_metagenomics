perl -e 'while(<>) { if(m/^([@+]ERR)/) { my $s = $1; my @p = split(/\s+/,$_); print $s; print $p[1]; print "\n";} else { print; } }'
