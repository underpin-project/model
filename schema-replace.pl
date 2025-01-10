#!perl -w
use strict;
use warnings;

our $refinery_extra = << 'EOF';
<schema/$ID/(n)>
  sosa:isObservedBy "(sensor)";
  sosa:hasFeatureOfInterest <tag/refinery-compressor/URLIFY(tag)>;
  un:alarmLowThreshold  "(alarmLowThreshold)"^^xsd:decimal;
  un:alarmHighThreshold "(alarmHighThreshold)"^^xsd:decimal;
  un:tripLowThreshold   "(tripLowThreshold)"^^xsd:decimal;
  un:tripHighThreshold  "(tripHighThreshold)"^^xsd:decimal.

<tag/refinery-compressor/URLIFY(tag)> a skos:Concept, sosa:FeatureOfInterest;
  skos:inScheme <tag>;
  skos:prefLabel "(tag)";
  skos:description "Refinery compressor (tag)".
EOF

our %PARAM =
  ("windfarm" =>
   {SHEET => "https://docs.google.com/spreadsheets/d/1wnnq20RinFOLhFjg-QiOcYo9XsisZ3ZaPwzq2G5_ogU/edit?gid=1189930306#gid=1189930306",
    NAME => "Windfarm",
    EXTRA => ""},

   "windfarm-generator2" =>
   {SHEET => "https://docs.google.com/spreadsheets/d/1wnnq20RinFOLhFjg-QiOcYo9XsisZ3ZaPwzq2G5_ogU/edit?gid=2142433981#gid=2142433981",
    NAME  => "Windfarm Generator Case 2",
    EXTRA => ""},

   "refinery" =>
   {SHEET => "https://docs.google.com/spreadsheets/d/1wnnq20RinFOLhFjg-QiOcYo9XsisZ3ZaPwzq2G5_ogU/edit?gid=870089929#gid=870089929",
    NAME  => "Refinery compressor",
    EXTRA => $refinery_extra},

   "refinery-result-anomaly" =>
   {SHEET => "https://docs.google.com/spreadsheets/d/1wnnq20RinFOLhFjg-QiOcYo9XsisZ3ZaPwzq2G5_ogU/edit?gid=699616734#gid=699616734",
    NAME  => "Refinery Prediction Results: Anomalies",
    EXTRA => ""},

   "windfarm-result" =>
   {SHEET => "https://docs.google.com/spreadsheets/d/1wnnq20RinFOLhFjg-QiOcYo9XsisZ3ZaPwzq2G5_ogU/edit?gid=1862782183#gid=1862782183",
    NAME  => "Windfarm Prediction Results",
    EXTRA => ""},
   );

# More complex variant for sosa:isObservedBy:
# <sensor/(sensor)> a skos:Concept, sosa:Sensor;
#   skos:inScheme <sensor>;
#   skos:prefLabel "(sensor)";
#   skos:description "Sensor (sensor)".

$/ = undef;
my $input = <>; # slurp STDIN
while (my ($ID,$param) = each %PARAM) {
  my $SHEET = $param->{SHEET};
  my $NAME  = $param->{NAME};
  my $EXTRA = $param->{EXTRA};
  $EXTRA = eval('qq{'.$EXTRA.'}');     # substitute $VARS
  my $output = eval('qq{'.$input.'}'); # substitute $VARS
  my $fname = "schema-$ID.ttl";
  open FILE, ">$fname" or die "can't create $fname: $!\n";
  print FILE $output;
  close FILE;
}
