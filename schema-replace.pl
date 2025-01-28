#!perl -w
use strict;
use warnings;

our %NAME =
  ("windfarm"                => "Windfarm",
   "windfarm-generator2"     => "Windfarm Generator Case 2",
   "windfarm-ait"            => "Windfarm AIT",
   "refinery"                => "Refinery compressor",
   "refinery-result-anomaly" => "Refinery Prediction Results: Anomalies",
   "windfarm-result"         => "Windfarm Prediction Results",
   );

# More complex variant for sosa:isObservedBy:
# <sensor/(sensor)> a skos:Concept, sosa:Sensor;
#   skos:inScheme <sensor>;
#   skos:prefLabel "(sensor)";
#   skos:description "Sensor (sensor)".

$/ = undef;
my $input = <>; # slurp STDIN
while (my ($ID,$NAME) = each %NAME) {
  my $output = $input;
  $output =~ s{\$ID}{$ID}g;
  $output =~ s{\$NAME}{$NAME}g;
  if ($ID eq "refinery") {
    open EXTRA, "schema-refinery-extra.txt" or die "can't open schema-refinery-extra.txt: $!\n";
    my $EXTRA = <EXTRA>;
    $EXTRA =~ s{\$ID}{$ID}g;
    $output .= $EXTRA;
  };
  my $fname = "schema-$ID.ttl";
  open FILE, ">$fname" or die "can't create $fname: $!\n";
  print FILE $output;
  close FILE;
}
