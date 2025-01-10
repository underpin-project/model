# Add dcat:keyword to dcat:Dataset from the skos:prefLabel of all its column characteristics

insert {graph ?g {?x dcat:keyword ?label}}
where {
  {graph ?g {?x a dcat:Dataset; 
};
