base <https://dataspace.underpinproject.eu/>
prefix un: <https://dataspace.underpinproject.eu/ontology/>
prefix csvw: <http://www.w3.org/ns/csvw#>
prefix dcat: <http://www.w3.org/ns/dcat#>
prefix dcat-ext: <https://semantic.sovity.io/dcat-ext#>
prefix dct: <http://purl.org/dc/terms/>
prefix edc: <https://w3id.org/edc/v0.0.1/ns/>
prefix odrl: <http://www.w3.org/ns/odrl/2/>
prefix owl: <http://www.w3.org/2002/07/owl#>
prefix prov: <http://www.w3.org/ns/prov#>
prefix puml: <http://plantuml.com/ontology#>
prefix qb: <http://purl.org/linked-data/cube#>
prefix qk: <http://qudt.org/vocab/quantitykind/>
prefix qudt: <http://qudt.org/schema/qudt/>
prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
prefix reliawind: <https://www.ieawindtask43.org/ontoforge/reliawind-taxonomy-wt-components/>
prefix schema: <http://schema.org/>
prefix sdmx-concept: <http://purl.org/linked-data/sdmx/2009/concept#>
prefix skos: <http://www.w3.org/2004/02/skos/core#>
prefix sosa: <http://www.w3.org/ns/sosa/>
prefix spif: <http://spinrdf.org/spif#>
prefix unit: <http://qudt.org/vocab/unit/>
prefix xsd: <http://www.w3.org/2001/XMLSchema#>
delete {graph ?graph_schema_windfarm_URL {?_s_ ?_p_ ?_o_}}
where {
  {select * { service <http://localhost:7333/repositories/ontorefine:data> {
    bind(iri(concat("graph/schema/windfarm")) as ?graph_schema_windfarm_URL)
  }}}
  graph ?graph_schema_windfarm_URL {?_s_ ?_p_ ?_o_}};
insert {graph ?graph_schema_windfarm_URL {
  <schema/windfarm> a csvw:Schema;
    dct:title "Windfarm table schema";
    csvw:column ?schema_windfarm_n_URL.
  ?schema_windfarm_n_URL a csvw:Column, sosa:ObservableProperty;
    csvw:title ?title;
    dct:identifier ?n_xsd_integer;
    csvw:name ?name;
    un:influxDatatype ?influxDatatype;
    csvw:suppressOutput ?suppressOutput_xsd_boolean;
    csvw:datatype ?schema_windfarm_n_dtBase_URL, ?xsd_datatype_URL;
    sosa:hasFeatureOfInterest ?feature_features_SPLIT_URLIFY_URL;
    un:qualifier ?qualifier_statisticalQualifiers_SPLIT_URL;
    qudt:hasQuantityKind ?qk_quantityKind_URL;
    qudt:hasUnit ?unit_unit_URL;
    rdfs:comment ?comment.
  ?feature_features_SPLIT_URLIFY_URL a skos:Concept, sosa:FeatureOfInterest;
    skos:inScheme <feature>;
    skos:prefLabel ?features_SPLIT.
  ?schema_windfarm_n_dtBase_URL a csvw:Datatype;
    csvw:base ?xsd_dtBase_URL;
    csvw:format ?format.
}}
where {
  service <http://localhost:7333/repositories/ontorefine:data> {
    bind(iri(concat("graph/schema/windfarm")) as ?graph_schema_windfarm_URL)
    bind(?c_n as ?n)
    bind(?c_title as ?title)
    bind(?c_name as ?name)
    bind(?c_influxDatatype as ?influxDatatype)
    bind(?c_suppressOutput as ?suppressOutput)
    bind(?c_dtBase as ?dtBase)
    bind(?c_features as ?features)
    bind(?c_statisticalQualifiers as ?statisticalQualifiers)
    bind(?c_comment as ?comment)
    bind(?c_format as ?format)
    bind(iri(concat("schema/windfarm/",?n)) as ?schema_windfarm_n_URL)
    bind(strdt(?n,xsd:integer) as ?n_xsd_integer)
    bind(strdt(?suppressOutput,xsd:boolean) as ?suppressOutput_xsd_boolean)
    bind(iri(concat("schema/windfarm/",?n,"/",?dtBase)) as ?schema_windfarm_n_dtBase_URL)
    bind(?c_datatype as ?datatype)
    bind(iri(concat(str(xsd:),?datatype)) as ?xsd_datatype_URL)
    ?features_SPLIT spif:split (?features ", ?").
    bind(lcase(replace(replace(replace(?features_SPLIT, "[^\\p{L}0-9]", "_"), "_+", "_"), "^_|_$", "")) as ?features_SPLIT_URLIFY)
    bind(iri(concat("feature/",?features_SPLIT_URLIFY)) as ?feature_features_SPLIT_URLIFY_URL)
    ?statisticalQualifiers_SPLIT spif:split (?statisticalQualifiers ", ?").
    bind(iri(concat("qualifier/",?statisticalQualifiers_SPLIT)) as ?qualifier_statisticalQualifiers_SPLIT_URL)
    bind(?c_quantityKind as ?quantityKind)
    bind(iri(concat(str(qk:),?quantityKind)) as ?qk_quantityKind_URL)
    bind(?c_unit as ?unit)
    bind(iri(concat(str(unit:),?unit)) as ?unit_unit_URL)
    bind(iri(concat(str(xsd:),?dtBase)) as ?xsd_dtBase_URL)
  }
};
