base         <https://dataspace.underpinproject.eu/>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix qudt: <http://qudt.org/schema/qudt/>

# Add skos:prefLabel from rdfs:label@en, for qudt:Unit and qudt:QuantityKind
insert {graph <graph/ontology-and-thesauri> {?x skos:prefLabel ?label}}
where {
  values ?type {qudt:Unit qudt:QuantityKind}
  graph ?g {?x a ?type; rdfs:label ?label}
  filter(lang(?label)="en")
};

# Remove parasitic prefLabel for qudt:Unit and qudt:QuantityKind
delete {graph ?g {?x skos:prefLabel ?label}}
where {
  values ?type {qudt:Unit qudt:QuantityKind}
  graph ?g {?x a ?type; skos:prefLabel ?label}
};

# Remove duplicate keywords
prefix dcat: <http://www.w3.org/ns/dcat#>
delete {?x dcat:keyword ?bad}
where {
  ?x dcat:keyword ?good, ?bad
  filter(str(?good)=str(?bad) && lang(?good)="en" && lang(?bad)="")
};