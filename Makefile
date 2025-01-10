SCHEMA = schema-windfarm.ttl schema-windfarm-generator2.ttl schema-windfarm-result.ttl schema-refinery.ttl schema-refinery-result-anomaly.ttl
UPDATES = $(patsubst %.ttl,%.ru,$(SCHEMA))

all: prefixes.rq $(SCHEMA) $(UPDATES) schema-refinery.png

prefixes.rq: prefixes.ttl
	perl -pe 'm{###} and last; s{^@}{}; s{ *\.$$}{}' $^ > $@

$(SCHEMA): schema-replace.pl schema-template.txt
	perl $^

%.png: %.ttl
	perl -S rdfpuml.pl $*.ttl
	plantuml $*.puml
	rm $*.puml

schema-%.ru: schema-%.ttl common.h prefixes.rq
	perl -S rdf2sparql.pl -e http://localhost:7333/repositories/ontorefine:$* schema-$*.ttl | cat common.h prefixes.rq - | cpp -P -C -nostdinc - > $@
