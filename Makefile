SCHEMA = schema-windfarm.ttl schema-windfarm-generator2.ttl schema-windfarm-ait.ttl schema-windfarm-result.ttl schema-refinery.ttl schema-refinery-result-anomaly.ttl
UPDATES = $(patsubst %.ttl, %.ru, $(SCHEMA) dataset.ttl)

all: prefixes.rq $(SCHEMA) $(UPDATES) schema-refinery.png dataset.png dataset-relations.png dataset-extra.png out/elastic-index-datasets.ru out/elastic-index-catalog.ru out/updates.ru

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
out/elastic-index-datasets.ru: elastic-index.yaml
	perl -S index-yaml-json-sparql.pl --index=datasets $^ > $@
out/elastic-index-catalog.ru: elastic-index.yaml
	perl -S index-yaml-json-sparql.pl --index=catalog $^ > $@

out/updates.ru: update-add-prefLabel.ru update-collect-feature-definitions.ru update-collect-keywords.ru update-fix-skos.ru update-participantId.ru
	cat $^ > $@
