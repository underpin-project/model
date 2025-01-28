prefix skos: <http://www.w3.org/2004/02/skos/core#>

# use skos:definition not skos:description
delete {graph ?g {?x skos:description ?y}}
insert {graph ?g {?x skos:definition  ?y}}
where  {graph ?g {?x skos:description ?y}};

# attach lang tag @en to skos:prefLabel and skos:definition
delete {graph ?g {?x ?p ?old}}
insert {graph ?g {?x ?p ?new}}
where  {graph ?g {
  values ?p {skos:prefLabel skos:definition}
  ?x ?p ?old
  filter(lang(?y)="")
  bind(strlang(?y,"en") as ?new)
}};

# add skos:hasTopConcept and skos:topConceptOf
insert {graph ?g {?c skos:topConceptOf ?s. ?s skos:hasTopConcept ?c}}
where  {graph ?g {
  ?c skos:inScheme ?s
  filter not exists {?c skos:broader ?d}
}};
