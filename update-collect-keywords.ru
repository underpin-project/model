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
