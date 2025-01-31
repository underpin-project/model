PREFIX elastic:      <http://www.ontotext.com/connectors/elasticsearch#>
PREFIX elastic-inst: <http://www.ontotext.com/connectors/elasticsearch/instance#>
INSERT DATA {
  elastic-inst:catalog elastic:createConnector '''
{
   "elasticsearchBasicAuthPassword" : "$secret",
   "elasticsearchBasicAuthUser" : "elastic",
   "elasticsearchNode" : "elasticsearch-es-internal-http.elastic.svc.cluster.local:9200",
   "fields" : [
      {
         "analyzed" : false,
         "fieldName" : "id",
         "propertyChain" : [
            "http://purl.org/dc/terms/identifier"
         ]
      },
      {
         "analyzed" : false,
         "fieldName" : "participantId",
         "propertyChain" : [
            "https://w3id.org/edc/v0.0.1/ns/participantId"
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
         "fieldName" : "startDate",
         "propertyChain" : [
            "http://purl.org/dc/terms/temporal",
            "http://www.w3.org/ns/dcat#startDate"
         ]
      },
      {
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
         "analyzed" : false,
         "array" : true,
         "fieldName" : "keywords",
         "propertyChain" : [
            "http://www.w3.org/ns/dcat#keyword"
         ]
      },
      {
         "datatype" : "native:text",
         "fieldName" : "text$1",
         "nativeSettings" : {
            "fields" : {
               "suggest" : {
                  "doc_values" : false,
                  "max_shingle_size" : 3,
                  "type" : "search_as_you_type"
               }
            }
         },
         "propertyChain" : [
            "http://purl.org/dc/terms/identifier"
         ]
      },
      {
         "analyze" : true,
         "datatype" : "native:completion",
         "fieldName" : "text_completion",
         "nativeSettings" : {
            "max_input_length" : 50,
            "preserve_position_increments" : true,
            "preserve_separators" : true
         },
         "propertyChain" : [
            "@text"
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
         "datatype" : "native:text",
         "fieldName" : "text$2",
         "nativeSettings" : {
            "fields" : {
               "suggest" : {
                  "doc_values" : false,
                  "max_shingle_size" : 3,
                  "type" : "search_as_you_type"
               }
            }
         },
         "propertyChain" : [
            "http://purl.org/dc/terms/title"
         ]
      },
      {
         "datatype" : "native:text",
         "fieldName" : "text$3",
         "nativeSettings" : {
            "fields" : {
               "suggest" : {
                  "doc_values" : false,
                  "max_shingle_size" : 3,
                  "type" : "search_as_you_type"
               }
            }
         },
         "propertyChain" : [
            "http://purl.org/dc/terms/publisher",
            "http://schema.org/name"
         ]
      },
      {
         "datatype" : "native:text",
         "fieldName" : "text$4",
         "nativeSettings" : {
            "fields" : {
               "suggest" : {
                  "doc_values" : false,
                  "max_shingle_size" : 3,
                  "type" : "search_as_you_type"
               }
            }
         },
         "propertyChain" : [
            "http://purl.org/dc/terms/temporal",
            "http://www.w3.org/ns/dcat#startDate"
         ]
      },
      {
         "datatype" : "native:text",
         "fieldName" : "text$5",
         "nativeSettings" : {
            "fields" : {
               "suggest" : {
                  "doc_values" : false,
                  "max_shingle_size" : 3,
                  "type" : "search_as_you_type"
               }
            }
         },
         "propertyChain" : [
            "http://purl.org/dc/terms/temporal",
            "http://www.w3.org/ns/dcat#endDate"
         ]
      },
      {
         "datatype" : "native:text",
         "fieldName" : "text$6",
         "nativeSettings" : {
            "fields" : {
               "suggest" : {
                  "doc_values" : false,
                  "max_shingle_size" : 3,
                  "type" : "search_as_you_type"
               }
            }
         },
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://purl.org/dc/terms/title"
         ]
      },
      {
         "datatype" : "native:text",
         "fieldName" : "text$7",
         "nativeSettings" : {
            "fields" : {
               "suggest" : {
                  "doc_values" : false,
                  "max_shingle_size" : 3,
                  "type" : "search_as_you_type"
               }
            }
         },
         "propertyChain" : [
            "http://purl.org/dc/terms/conformsTo",
            "http://www.w3.org/ns/csvw#column",
            "http://purl.org/dc/terms/title"
         ]
      },
      {
         "datatype" : "native:text",
         "fieldName" : "text$8",
         "nativeSettings" : {
            "fields" : {
               "suggest" : {
                  "doc_values" : false,
                  "max_shingle_size" : 3,
                  "type" : "search_as_you_type"
               }
            }
         },
         "propertyChain" : [
            "http://www.w3.org/ns/dcat#keyword"
         ]
      }
   ],
   "types" : [
      "http://www.w3.org/ns/dcat#Dataset"
   ]
}

''' .
}
