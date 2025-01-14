base         <https://dataspace.underpinproject.eu/>
prefix sosa: <http://www.w3.org/ns/sosa/>

delete {graph ?g {?x ?p ?o}}
insert {graph <graph/ontology-and-thesauri> {?x ?p ?o}}
where {graph ?g {?x a sosa:FeatureOfInterest; ?p ?o}};
