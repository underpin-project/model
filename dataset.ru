base <https://dataspace.underpinproject.eu/>
prefix un: <https://dataspace.underpinproject.eu/ontology/>
prefix csvw: <http://www.w3.org/ns/csvw#>
prefix dcat: <http://www.w3.org/ns/dcat#>
prefix dct: <http://purl.org/dc/terms/>
prefix edc: <https://w3id.org/edc/v0.0.1/ns/>
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
delete {graph ?graph_dataset_dataset_URL {?_s_ ?_p_ ?_o_}}
where {
  {select * { service <http://localhost:7333/repositories/ontorefine:data> {
    bind(?c_dataset as ?dataset)
    bind(iri(concat("graph/dataset/",?dataset)) as ?graph_dataset_dataset_URL)
  }}}
  graph ?graph_dataset_dataset_URL {?_s_ ?_p_ ?_o_}};
insert {graph ?graph_dataset_dataset_URL {
  ## SHEET https://docs.google.com/spreadsheets/d/1wnnq20RinFOLhFjg-QiOcYo9XsisZ3ZaPwzq2G5_ogU/edit?gid=1341812003#gid=1341812003
  ?dataset_dataset_URL
    a dcat:Dataset, ?dcat_type_URL ;
    dct:title ?title ;
    dct:identifier ?dataset ;
    edc:id ?dataset;
    dct:type ?type_type1_URL, ?type_type2_URL;
    dcat:keyword ?keywords_SPLIT;
    dct:conformsTo ?schema_schema_URL;
    dct:creator ?org_org_URL;
    dct:publisher ?org_org_URL;
    edc:participantId ?participantId;
    dct:license <https://creativecommons.org/licenses/by/4.0/> ;
    dct:spatial ?tag;
    dct:temporal ?dataset_dataset_temporal_URL;
    ## dct:accrualPeriodicity ?accrual_xsd_duration;
    dcat:distribution ?dataset_dataset_distribution_URL;
    dcat:inSeries ?dataset_inSeries_URL;
    prov:wasDerivedFrom ?dataset_derivedFrom_URL.
  ?dataset_dataset_temporal_URL a dct:PeriodOfTime;
    dcat:startDate ?startDate_xsd_date ;
    dcat:endDate ?endDate_xsd_date.
  ?dataset_dataset_distribution_URL a dcat:Distribution ;
    dct:format ?format;
    edc:type ?type3.
}}
where {
  service <http://localhost:7333/repositories/ontorefine:data> {
    bind(?c_dataset as ?dataset)
    bind(iri(concat("graph/dataset/",?dataset)) as ?graph_dataset_dataset_URL)
    bind(?c_title as ?title)
    bind(?c_type1 as ?type1)
    bind(?c_type2 as ?type2)
    bind(?c_keywords as ?keywords)
    bind(?c_schema as ?schema)
    bind(?c_org as ?org)
    bind(?c_participantId as ?participantId)
    bind(?c_tag as ?tag)
    bind(?c_accrual as ?accrual)
    bind(?c_inSeries as ?inSeries)
    bind(?c_derivedFrom as ?derivedFrom)
    bind(?c_startDate as ?startDate)
    bind(?c_endDate as ?endDate)
    bind(?c_format as ?format)
    bind(?c_type3 as ?type3)
    bind(iri(concat("dataset/",?dataset)) as ?dataset_dataset_URL)
    bind(?c_type as ?type)
    bind(iri(concat(str(dcat:),?type)) as ?dcat_type_URL)
    bind(iri(concat("type/",?type1)) as ?type_type1_URL)
    bind(iri(concat("type/",?type2)) as ?type_type2_URL)
    ?keywords_SPLIT spif:split (?keywords ", ?").
    bind(iri(concat("schema/",?schema)) as ?schema_schema_URL)
    bind(iri(concat("org/",?org)) as ?org_org_URL)
    bind(iri(concat("dataset/",?dataset,"/temporal")) as ?dataset_dataset_temporal_URL)
    bind(strdt(?accrual,xsd:duration) as ?accrual_xsd_duration)
    bind(iri(concat("dataset/",?dataset,"/distribution")) as ?dataset_dataset_distribution_URL)
    bind(iri(concat("dataset/",?inSeries)) as ?dataset_inSeries_URL)
    bind(iri(concat("dataset/",?derivedFrom)) as ?dataset_derivedFrom_URL)
    bind(strdt(?startDate,xsd:date) as ?startDate_xsd_date)
    bind(strdt(?endDate,xsd:date) as ?endDate_xsd_date)
  }
};
