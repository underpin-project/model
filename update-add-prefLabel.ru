# Adds skos:prefLabel from rdfs:label@en, for qudt:Unit and qudt:QuantityKind
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix qudt: <http://qudt.org/schema/qudt/>

insert {graph ?g {?x skos:prefLabel ?new}}
where {
  values ?type {qudt:Unit qudt:QuantityKind}
  graph ?g {?x a ?type; rdfs:label ?old}
  filter(lang(?old)="en")
  bind(str(?old) as ?new)
};
