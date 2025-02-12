SCHEMA = schema-windfarm.ttl schema-windfarm-generator2.ttl schema-windfarm-ait.ttl schema-windfarm-result.ttl schema-refinery.ttl schema-refinery-result-anomaly.ttl
UPDATES = $(patsubst %.ttl, %.ru, $(SCHEMA) dataset.ttl)
GSHEETS = $(patsubst %.ttl, google-sheets/%.csv, $(SCHEMA) dataset.ttl)

all: prefixes.rq $(SCHEMA) $(UPDATES) $(GSHEETS) schema-refinery.png dataset.png dataset-relations.png dataset-extra.png out/elastic-index-datasets.ru out/elastic-index-catalog.ru out/updates.ru

dataset-extra.ttl: dataset.ttl dataset-extra.txt
	cat $^ > $@

prefixes.rq: prefixes.ttl
	perl -pe 'm{###} and last; s{^@}{}; s{ *\.$$}{}' $^ > $@

$(SCHEMA): schema-replace.pl schema-template.txt
	perl $^

$(GSHEETS): scripts/get-google-sheets.sh google-sheets/config.yaml
	./scripts/get-google-sheets.sh $(notdir $@)

%.png: %.ttl prefixes.ttl
	perl -S rdfpuml.pl $*.ttl
	plantuml $*.puml
	rm $*.puml

%.ru: %.ttl common.h prefixes.rq
	perl -S rdf2sparql.pl -e http://localhost:7333/repositories/ontorefine:data $*.ttl | cat common.h prefixes.rq - | cpp -P -C -nostdinc - > $@

# TODO: this leaves a word "$secret": replace with actual password, but don't commit to github
out/elastic-index-datasets.ru: elastic-index.yaml
	perl -S index-yaml-json-sparql.pl --index=datasets $^ > $@
out/elastic-index-catalog.ru: elastic-index.yaml
	perl -S index-yaml-json-sparql.pl --index=catalog $^ > $@

out/updates.ru: $(wildcard updates/*.ru)
	cat $(sort $^) > $@
