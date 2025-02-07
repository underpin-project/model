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

base         <https://dataspace.underpinproject.eu/>
prefix sosa: <http://www.w3.org/ns/sosa/>

delete {graph ?g {?x ?p ?o}}
insert {graph <graph/ontology-and-thesauri> {?x ?p ?o}}
where  {graph ?g {?x a sosa:FeatureOfInterest; ?p ?o}};

prefix un:   <https://dataspace.underpinproject.eu/ontology/>
prefix csvw: <http://www.w3.org/ns/csvw#>
prefix dcat: <http://www.w3.org/ns/dcat#>
prefix dct:  <http://purl.org/dc/terms/>
prefix qudt: <http://qudt.org/schema/qudt/>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix sosa: <http://www.w3.org/ns/sosa/>

insert {graph ?g {?x dcat:keyword ?keyword}}
where {
  graph ?g {?x a dcat:Dataset}
  ?x dct:spatial|(dct:type|dct:conformsTo/csvw:column/(un:qualifier|qudt:hasUnit|qudt:hasQuantityKind|sosa:hasFeatureOfInterest))/skos:prefLabel ?keyword
};

prefix skos:   <http://www.w3.org/2004/02/skos/core#>
prefix dct:    <http://purl.org/dc/terms/>
prefix dcat:   <http://www.w3.org/ns/dcat#>
prefix schema: <http://schema.org/>

# use skos:definition not skos:description
delete {graph ?g {?x skos:description ?y}}
insert {graph ?g {?x skos:definition  ?y}}
where  {graph ?g {?x skos:description ?y}};

# attach lang tag @en to all textual props
delete {graph ?g {?x ?p ?old}}
insert {graph ?g {?x ?p ?new}}
where  {graph ?g {
  values ?p {skos:prefLabel skos:definition schema:name dcat:keyword dct:title dct:description}
  ?x ?p ?old
  filter(lang(?old)="")
  bind(strlang(?old,"en") as ?new)
}};

# add skos:hasTopConcept and skos:topConceptOf
insert {graph ?g {?c skos:topConceptOf ?s. ?s skos:hasTopConcept ?c}}
where  {graph ?g {
  ?c skos:inScheme ?s
  filter not exists {?c skos:broader ?d}
}};

prefix edc:          <https://w3id.org/edc/v0.0.1/ns/>

# Add connector Id (after the dot) to the participantId field of Organization and Dataset
# Fix (last row in table)
delete {graph ?g {?x edc:participantId ?old}}
insert {graph ?g {?x edc:participantId ?new}}
where {
  values (?old ?new) {
    ("BPNLY38WC4" "BPNLY38WC4.CLEGCS4")
    ("BPNL0C3QGE" "BPNL0C3QGE.CCD3IOO")
    ("BPNLY3SEIW" "BPNLY3SEIW.CV064VJ")
    ("BPNL512R1Q" "BPNL512R1Q.C782W3N")
    ("BPNLJ3NRCO" "BPNLJ3NRCO.CO52UNS") # this is https://demo-connector-1.dataspace.underpinproject.eu, preferred to https://demo-connector-2.dataspace.underpinproject.eu
    ("BPNLRIN7QO" "BPNLOK5DHX.CFXO08H") # Organization Id of SPH was wrong https://github.com/underpin-project/dataspace/issues/63
  }
  graph ?g {?x edc:participantId ?old}
};

