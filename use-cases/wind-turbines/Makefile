all: wt-events.png

%.png: %.ttl
	perl -SC rdfpuml.pl $*.ttl
	plantuml $*.puml
	rm $*.puml
