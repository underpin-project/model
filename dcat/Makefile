all: dataspace-catalog-with-context1.png

%.png: %.ttl | prefixes.ttl
	perl -S rdfpuml.pl $*.ttl
	plantuml $*.puml
	rm $*.puml
