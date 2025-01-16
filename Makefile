SCHEMA = schema-windfarm.ttl schema-windfarm-generator2.ttl schema-windfarm-result.ttl schema-refinery.ttl schema-refinery-result-anomaly.ttl
UPDATES = $(patsubst %.ttl, %.ru, $(SCHEMA) dataset.ttl)

all: prefixes.rq $(SCHEMA) $(UPDATES) schema-refinery.png dataset.png dataset-extra.png elastic-index.ru

dataset-extra.ttl: dataset.ttl dataset-extra.txt
	cat $^ > $@

prefixes.rq: prefixes.ttl
	perl -pe 'm{###} and last; s{^@}{}; s{ *\.$$}{}' $^ > $@

$(SCHEMA): schema-replace.pl schema-template.txt
	perl $^

%.png: %.ttl prefixes.ttl
	perl -S rdfpuml.pl $*.ttl
	plantuml $*.puml
	rm $*.puml

%.ru: %.ttl common.h prefixes.rq
	perl -S rdf2sparql.pl -e http://localhost:7333/repositories/ontorefine:data $*.ttl | cat common.h prefixes.rq - | cpp -P -C -nostdinc - > $@

# TODO: this leaves a word "$secret": replace with actual password, but don't commit to github
elastic-index.ru: elastic-index.yaml
	perl -S index-yaml-json-sparql.pl $^ > $@
