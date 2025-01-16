PREFIX elastic:      <http://www.ontotext.com/connectors/elasticsearch#>
PREFIX elastic-inst: <http://www.ontotext.com/connectors/elasticsearch/instance#>
INSERT DATA {
  es-inst:index es:createConnector '''
{
   "elasticsearchBasicAuthPassword" : "$secret",
   "elasticsearchBasicAuthUser" : "write",
   "elasticsearchNode" : "https://elastic.dataspace.underpinproject.eu/",
   "fields" : [
      {
         "analyzed" : false,
         "fieldName" : "id",
         "propertyChain" : [
            "http://purl.org/dc/terms/identifier"
         ]
      },
      {
         "analyzed" : true,
         "fieldName" : "title",
         "propertyChain" : [
            "http://purl.org/dc/terms/title"
         ]
      },
      {
         "analyzed" : false,
         "fieldName" : "publisher",
         "propertyChain" : [
            "http://purl.org/dc/terms/publisher",
            "http://schema.org/name"
         ]
      },
      {
         "analyzed" : false,
         "array" : true,
         "fieldName" : "types",
         "propertyChain" : [
            "http://purl.org/dc/terms/type",
            "http://www.w3.org/2004/02/skos/core#prefLabel"
         ]
      },
      {
         "analyzed" : false,
         "fieldName" : "startDate",
         "propertyChain" : [
            "http://purl.org/dc/terms/temporal",
            "http://www.w3.org/ns/dcat#startDate"
         ]
      },
      {
         "analyzed" : false,
         "fieldName" : "endDate",
         "propertyChain" : [
            "http://purl.org/dc/terms/temporal",
            "http://www.w3.org/ns/dcat#endDate"
         ]
      },
      {
         "analyzed" : false,
         "fieldName" : "tag",
         "propertyChain" : [
            "http://purl.org/dc/terms/spatial"
         ]
      },
      {
         "analyzed" : false,
         "fieldName" : "schema",
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://purl.org/dc/terms/title"
         ]
      },
      {
         "analyzed" : true,
         "fieldName" : "text$1",
         "propertyChain" : [
            "http://purl.org/dc/terms/identifier"
         ]
      },
      {
         "analyzed" : false,
         "array" : true,
         "fieldName" : "keywords$1",
         "propertyChain" : [
            "http://www.w3.org/ns/dcat#keyword"
         ]
      },
      {
         "array" : true,
         "datatype" : "native:nested",
         "fieldName" : "column",
         "objectFields" : [
            {
               "analyzed" : false,
               "array" : true,
               "fieldName" : "features",
               "propertyChain" : [
                  "http://www.w3.org/ns/sosa/hasFeatureOfInterest",
                  "http://www.w3.org/2004/02/skos/core#prefLabel"
               ]
            },
            {
               "analyzed" : false,
               "array" : true,
               "fieldName" : "qualifiers",
               "propertyChain" : [
                  "https://dataspace.underpinproject.eu/ontology/qualifier",
                  "http://www.w3.org/2004/02/skos/core#prefLabel"
               ]
            },
            {
               "analyzed" : false,
               "fieldName" : "quantity",
               "propertyChain" : [
                  "http://qudt.org/schema/qudt/hasQuantityKind",
                  "http://www.w3.org/2004/02/skos/core#prefLabel"
               ]
            },
            {
               "analyzed" : false,
               "fieldName" : "unit",
               "propertyChain" : [
                  "http://qudt.org/schema/qudt/hasUnit",
                  "http://www.w3.org/2004/02/skos/core#prefLabel"
               ]
            }
         ],
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://www.w3.org/ns/csvw#column"
         ]
      },
      {
         "fieldName" : "text$2",
         "propertyChain" : [
            "http://purl.org/dc/terms/title"
         ]
      },
      {
         "fieldName" : "text$3",
         "propertyChain" : [
            "http://purl.org/dc/terms/publisher",
            "http://schema.org/name"
         ]
      },
      {
         "fieldName" : "text$4",
         "propertyChain" : [
            "http://purl.org/dc/terms/type",
            "http://www.w3.org/2004/02/skos/core#prefLabel"
         ]
      },
      {
         "fieldName" : "text$5",
         "propertyChain" : [
            "http://purl.org/dc/terms/temporal",
            "http://www.w3.org/ns/dcat#startDate"
         ]
      },
      {
         "fieldName" : "text$6",
         "propertyChain" : [
            "http://purl.org/dc/terms/temporal",
            "http://www.w3.org/ns/dcat#endDate"
         ]
      },
      {
         "fieldName" : "text$7",
         "propertyChain" : [
            "http://purl.org/dc/terms/spatial"
         ]
      },
      {
         "fieldName" : "text$8",
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://purl.org/dc/terms/title"
         ]
      },
      {
         "fieldName" : "text$9",
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://www.w3.org/ns/csvw#column",
            "http://purl.org/dc/terms/title"
         ]
      },
      {
         "fieldName" : "keywords$2",
         "propertyChain" : [
            "http://purl.org/dc/terms/type",
            "http://www.w3.org/2004/02/skos/core#prefLabel"
         ]
      },
      {
         "fieldName" : "keywords$3",
         "propertyChain" : [
            "http://purl.org/dc/terms/spatial"
         ]
      },
      {
         "fieldName" : "keywords$4",
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://www.w3.org/ns/csvw#column",
            "http://www.w3.org/ns/sosa/hasFeatureOfInterest",
            "http://www.w3.org/2004/02/skos/core#prefLabel"
         ]
      },
      {
         "fieldName" : "keywords$5",
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://www.w3.org/ns/csvw#column",
            "https://dataspace.underpinproject.eu/ontology/qualifier",
            "http://www.w3.org/2004/02/skos/core#prefLabel"
         ]
      },
      {
         "fieldName" : "keywords$6",
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://www.w3.org/ns/csvw#column",
            "http://qudt.org/schema/qudt/hasQuantityKind",
            "http://www.w3.org/2004/02/skos/core#prefLabel"
         ]
      },
      {
         "fieldName" : "keywords$7",
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://www.w3.org/ns/csvw#column",
            "http://qudt.org/schema/qudt/hasUnit",
            "http://www.w3.org/2004/02/skos/core#prefLabel"
         ]
      }
   ],
   "types" : [
      "dcat:Dataset"
   ]
}

''' .
}
