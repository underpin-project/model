SCHEMA = schema-windfarm.ttl schema-windfarm-generator2.ttl schema-windfarm-ait.ttl schema-windfarm-result.ttl schema-refinery.ttl schema-refinery-result-anomaly.ttl
UPDATES = $(patsubst %.ttl, %.ru, $(SCHEMA) dataset.ttl)
GSHEETS = $(patsubst %.ttl, google-sheets/%.csv, $(SCHEMA) dataset.ttl)
REFGDB = $(patsubst %.ttl, ontorefine-gdb-load/initial-data/%.loaded, $(SCHEMA) dataset.ttl)
GDB_URL = http://localhost:7200/repositories/underpin/statements

all: prefixes.rq $(SCHEMA) $(UPDATES) $(GSHEETS) $(REFGDB) schema-refinery.png dataset.png dataset-relations.png dataset-extra.png out/elastic-index-datasets.ru out/elastic-index-catalog.ru out/updates.ru ontorefine-gdb-load/reference-ontologies.loaded ontorefine-gdb-load/initial-data/underpin.loaded ontorefine-gdb-load/update-queries.loaded out/schema-dataset.trig ontorefine-gdb-load/tests.ok

dataset-extra.ttl: dataset.ttl dataset-extra.txt
	cat $^ > $@

prefixes.rq: prefixes.ttl
	perl -pe 'm{###} and last; s{^@}{}; s{ *\.$$}{}' $^ > $@

$(SCHEMA): schema-replace.pl schema-template.txt
	perl $^

$(GSHEETS): scripts/get-google-sheets.sh google-sheets/config.yaml
	./scripts/get-google-sheets.sh $(notdir $@)

ontorefine-gdb-load/initial-data/%.loaded: google-sheets/%.csv %.ru scripts/ontorefine-gdb-load.sh ontorefine-gdb-load/config.yaml
	./scripts/ontorefine-gdb-load.sh google-sheets/$*.csv $*.ru

#todo write a loader script
ontorefine-gdb-load/reference-ontologies.loaded: $(shell find reference-ontologies -type f) $(shell find ontorefine-gdb-load/initial-data -type f)
	for file in $(shell find reference-ontologies -type f); do \
	    echo "Processing $$file..."; \
	    curl -X POST -H "Content-Type: text/turtle" \
		                 --data-binary "@$$file" \
		                 "$(GDB_URL)?context=%3Chttps%3A%2F%2Fdataspace.underpinproject.eu%2Fgraph%2Freference-ontologies%3E"; \
	done
	touch ontorefine-gdb-load/reference-ontologies.loaded

ontorefine-gdb-load/initial-data/underpin.loaded : out/underpin.trig
	curl -X POST -H "Content-Type: application/trig" --data-binary "@$^" "$(GDB_URL)"
	touch ontorefine-gdb-load/initial-data/underpin.loaded

out/updates.ru: $(wildcard updates/*.ru)
	cat $(sort $^) > $@

ontorefine-gdb-load/update-queries.loaded: out/updates.ru ontorefine-gdb-load/reference-ontologies.loaded
	curl -X POST -H "Content-Type: application/sparql-update" --data-binary "@out/updates.ru" "$(GDB_URL)"
	touch ontorefine-gdb-load/update-queries.loaded

ontorefine-gdb-load/tests.ok : ontorefine-gdb-load/update-queries.loaded $(wildcard test/*.rq)
	./scripts/run-tests.sh

out/schema-dataset.trig : ontorefine-gdb-load/tests.ok
	curl -X GET -H "Accept:application/x-trig" "$(GDB_URL)" > tmp.trig
	sed '/###/q' prefixes.ttl | cat - tmp.trig | riot --base https://dataspace.underpinproject.eu/ --syntax trig --formatted trig > out/schema-dataset.trig

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
