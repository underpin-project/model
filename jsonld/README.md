# UNDERPIN JSON-LD Conversion
<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [UNDERPIN JSON-LD Conversion](#underpin-json-ld-conversion)
    - [Intro](#intro)
    - [JSON-LD Context](#json-ld-context)
    - [Context Whitelist](#context-whitelist)
    - [Sample Files](#sample-files)
    - [JSON-LD From GraphDB](#json-ld-from-graphdb)
    - [JSON-LD from Dataspace](#json-ld-from-dataspace)
    - [Conversion with Command-Line Tools](#conversion-with-command-line-tools)
- [Update Mar 2025](#update-mar-2025)
    - [Files](#files)

<!-- markdown-toc end -->



## Intro
[Dataspace Catalog Response](../dcat/#dataspace-catalog-response) criticizes the JSON metadata payload coming out of the dataspace, 
and problems related to converting it to RDF.

This discusses proper JSON-LD:
- Serialize JSONLD out of the repo and compact it using a context.
- Parse (interpret) a JSONLD to ingest to the repo.

## JSON-LD Context

The UNDERPIN JSON-LD [context.json](../context.json) is deployed at
https://rawgit2.com/underpin-project/model/main/context.json .
It reuses the DSP context and adds more property definitions (unfortunately these need to use full prop URLs since our data also uses full prop URLs)

## Context Whitelist
https://github.com/underpin-project/dataspace/issues/59 

As per [GraphDB documentation](https://graphdb.ontotext.com/documentation/10.8/exporting-data.html), any context URLs (network contexts) should be added to `graphdb.jsonld.whitelist` for security reasons.
We use the following whitelist:
```
https://rawgit2.com/underpin-project/*, https://w3id.org/dspace/*, https://international-data-spaces-association.github.io/*
```

## Sample Files
Currently UNDERPIN keeps each dataset in its own graph.
We download the following graphs from https://graphdb.dataspace.underpinproject.eu/graphs repo `dataspace`:
- `https://dataspace.underpinproject.eu/graph/dataset/windfarm-WF1-WTG01-2020.csv`
- `https://dataspace.underpinproject.eu/graph/dataset/dataset-refinery-compressor-2022-03.csv`

We download as:
- Turtle: `dataset-refinery-compressor-2022-03.csv.ttl, dataset-windfarm-WF1-WTG01-2020.csv.ttl`
- JSON-LD Expanded: `dataset-windfarm-WF1-WTG01-2020.csv-expanded.jsonld`
- JSON-LD Compacted: `dataset-windfarm-WF1-WTG01-2020.csv-compacted.jsonld`

TODO: describe how to download with the API.

## JSON-LD From GraphDB
Here is the result from GraphDB.
I have shortened it a bit and added comments:

```json
{
    "@id": "graph/dataset/windfarm-WF1-WTG01-2020.csv", # graph ID
    "@graph": [
        {
            "@id": "dataset/windfarm-WF1-WTG01-2020.csv/distribution",
            "@type": "dcat:Distribution",
            "dct:format": "text/csv"
        },
        {
            "@id": "dataset/windfarm-WF1-WTG01-2020.csv",
            "@type": "dcat:Dataset",
            "http://purl.org/dc/terms/title": # why full URL?
              "Wind turbine WF1-WTG01 sensor data for 2020 as csv",
            "dct:creator": "org/MORE",
            "dct:license": "https://creativecommons.org/licenses/by/4.0/",
            "dct:publisher": "org/MORE",
            "dcat:distribution": "dataset/windfarm-WF1-WTG01-2020.csv/distribution",
            "dcat:inSeries": "dataset/windfarm-WF1-2020-influx",
            "dcat:keyword": [ 
                "Spinner", "Parameter", # ... includes keywords collected from column characteristics
                { # YACK: QUDT prefLabels have lang tag, so they come out like this:
                    "@language": "en",
                    "@value": "Active Power"
                }
            ],
            "edc:participantId": "BPNL512R1Q",
            "dct:conformsTo": "schema/windfarm",
            "dct:identifier": "windfarm-WF1-WTG01-2020.csv",
            "dct:type": ["type/csv", "type/input"],
            "dct:spatial": "WF1-WTG01",
            "dct:temporal": "dataset/windfarm-WF1-WTG01-2020.csv/temporal",
            "edc:id": "windfarm-WF1-WTG01-2020.csv"
        },
        {  # not embedded as subnode of Dataset
            "@id": "dataset/windfarm-WF1-WTG01-2020.csv/temporal",
            "@type": "dct:PeriodOfTime",
            "dcat:endDate": "2022-12-31",
            "dcat:startDate": "2022-01-01"
        }
    ],
    "@context": [
      # repeats our context,
    ]
}
```
The result is nearly perfect.
Minor defects:
- TODO: The context is copied rather than referenced by URL https://ontotext.atlassian.net/browse/GDB-11598 .
  May need to cut it out before feeding to the dataspace connector.
- `dct:title` is emitted as full URL, despite my attempt to override `@lang: ""`.
  This is a minor cosmetic defect
- TODO: `dct:temporal` is not embedded as subnode of Dataset.
  We'll have to use a Frame to specify this
- `dcat:keyword` has a mixture of plain strings and langStrings (QUDT prefLabels have).
  TODO: is that a problem?
- There is a graph `@id`. 
  - This may confuse the dataspace connector and may need to be removed
  - This would be useful for the GraphDB Ingester to know which graph to address.

## JSON-LD from Dataspace
- [dataset-refinery-compressor-2022-01-from-dataspace.jsonld](dataset-refinery-compressor-2022-01-from-dataspace.jsonld) is a result from the Federated Catalog, after registering a DataAsset with similar metadata as above
- [dataset-refinery-compressor-2022-01-from-dataspace.ttl](dataset-refinery-compressor-2022-01-from-dataspace.ttl) is converted to Turtle with prefixes (see end of next section)

It has the following differences:
- `<edc:participantId>` "BPNLY3SEIW.CV064VJ" includes also the connector ID
  - "participant" means "connector". The first part is only the organization ID
  - Vlado to change it in gsheet
- `dct:description` has the same value as `dct:title`
  - Remove it, no need to duplicate this text
- has `dcat:version`
- has `<odrl:Set>` but we don't need it
  - We should delete it because the node URL is defective.
  - Ivan to delete `"odrl:hasPolicy"` from JSONLD in the Ingester (https://github.com/underpin-project/dataspace/issues/61) 
  - Sotiris: we may want to retain it for future use
  - Vlado: but the URL is unpredictable: 
    - `crap==:poop` is interpreted as `<https://dataspace.underpinproject.eu/crap==:poop>` 
    - whereas `crap:poop` is interpreted as `<crap:poop>` which is invalid URL scheme, and GraphDB will reject it unless we have the option "ingest invalid URLs"
    - `=` is used as a filler char in `base64` encoding, so it may or may not be present in the first part

And the following defects:
- The prefix of dataset URLs should be `dataset` not `dataspace`
- There is no context, so:
  - The following URLs are wrong
    - `<dcat:Dataset>, <edc:id>, <edc:participantId>, <odrl:*>` (many), but we don't care about ODRL
  - The following are string but should be URLs:
    - `dct:conformsTo, dct:creator, dct:identifier, dct:language, dct:publisher`
    - `dcat:inSeries, prov:wasDerivedFrom`
    - `<odrl:target>` (twice)
  - Ivan to insert a context in the Ingester, as second line in the payload (after the opening bracket) (https://github.com/underpin-project/dataspace/issues/61):
```
  "@context": "https://rawgit2.com/underpin-project/model/main/context.json",
```
- `edc:id` should be `refinery-compressor-2022-01.csv` and not a full URL
  - Sotiris: the reason is that `@id` is populated from `edc:id`
  - Vlado: I'll extend `@base` to `https://dataspace.underpinproject.eu/dataset`, 
    so you can use the short version in `edc:id`
- These types are missing ("The `@type` for `temporal` and `distribution` was not accepted so I had to remove it"):
  - `dcat:Distribution`
  - `dct:PeriodOfTime`
  - TODO: this will remain open
- Have you added `dct:spatial`?
  - It's only in Windfarm datasets so I can't check
  - Yes but it is not used in refinery data
- `<odrl:Set>` has bad URL (no base, and value is not suitable for URL), 
  so it gets the local filename as URL (`<file:///d:/Onto/proj/underpin/model/jsonld/dataset-refinery-compressor-2022-01-from-dataspace.jsonld> .`)
  - Same for `<odrl:hasPolicy>`


## Conversion with Command-Line Tools
We can use https://www.npmjs.com/package/jsonld to manipulate JSON at the command line and experiment with different representations.

Eg both of these produce the same. It differs from the GraphDB result only that it emits a network rather than copied context.
```
jsonld compact -c https://rawgit2.com/underpin-project/model/main/context.json dataset-windfarm-WF1-WTG01-2020.csv-compacted.jsonld
jsonld compact -c https://rawgit2.com/underpin-project/model/main/context.json dataset-windfarm-WF1-WTG01-2020.csv-expanded.jsonld
```

These convert JSONLD to RDF: the first to NQuads, the second to Turtle:
```
jsonld toRdf -q dataset-refinery-compressor-2022-01-from-dataspace.jsonld
riot.bat --formatted ttl dataset-refinery-compressor-2022-01-from-dataspace.jsonld
```
Neither of these produces prefixed prop URLs, so I prepend `prefixes.ttl` to see the result in a better way:
```
riot.bat --formatted ttl dataset-refinery-compressor-2022-01-from-dataspace.jsonld | cat ../prefixes.ttl - | riot.bat --syntax ttl -formatted ttl > dataset-refinery-compressor-2022-01-from-dataspace.ttl
```

# Update Mar 2025

## Files
- `prefixes.ttl`: copied from top folder, puml triples removed. 
  This is used to prefixize (prettify) turtle files
- `dspace-context.json`: parent context, downloaded from https://w3id.org/dspace/2024/1/context.json
- `json-ld-example.jsonld`: downloaded from the dataspace, reduced to 2 datasets and 2 keywords per dataset, reformatted basic JSON structure
- `json-ld-example1.ttl`: made with this command:
```
riot.bat -out ttl json-ld-example.jsonld |cat prefixes.ttl - | riot.bat -syntax ttl -formatted ttl > json-ld-example.ttl
```
- `json-ld-example2.ttl`: made with this command:
```
jsonld toRdf -q json-ld-example.jsonld|cat prefixes.ttl - | riot.bat -syntax ttl -formatted ttl > json-ld-example2.ttl
```

Fixes:
- The basic JSON structure was wrong: the context doesn't apply to all blocks. 
  See https://w3c.github.io/json-ld-syntax/#example-describing-disconnected-nodes-with-graph for the right structure: 
  we need to use `@graph` for multiple dataset nodes. This caused basic errors like `<dcat:Dataset>` and `<odrl:policy>` (invalid URL schemes instead of prefixes)
- Unfortunately the context needs to use full URLs in prop definitions since the data also uses full URLs
- Removed prefixes that are already defined in the base context (dspace-context.jsonld)
- Added prefix `dcat-ext: https://semantic.sovity.io/dcat-ext#`
- Removed `"dct:title": {"@language": ""}` because it caused error `Language tag [] is not well formed`

About the malformed ORDL `@id: Y29udHJhY3QtcmVmaW5lcnktY29tcHJlc3Nvci0yMDIyLTAxLmNzdg==:cmVmaW5lcnktY29tcHJlc3Nvci0yMDIyLTAxLmNzdg==:MDE5NThmMmUtMjIwMi03YzgxLTg2OWYtMjdmMjczMTJkODc5`
- Java program `riot` (from Jena) interprets it as `<>` (i.e. the base with empty local part).
  This is not ok since different ODRL sets (policies) will be collapsed to the same node
- JS NPM module `jsonld` (also used on the JSONLD Playground) interprets it as intended, i.e. prepends the base. 
  Although that's an ugly (and perhaps invalid) URL, at least it will be different 
- Titanium (rdf4j JSONLD parser): I don't know what it will do. If it discards the local part, the only recourse is rewrite or remove the ugly URL.

Here's the critical part:
```
"@type" : "dcat:Dataset",
"odrl:hasPolicy" : {
  "@id" : "Y29udHJhY3QtcmVmaW5lcnktY29tcHJlc3Nvci0yMDIyLTAxLmNzdg==:cmVmaW5lcnktY29tcHJlc3Nvci0yMDIyLTAxLmNzdg==:MDE5NThmMmUtMjIwMi03YzgxLTg2OWYtMjdmMjczMTJkODc5",
  "@type" : "odrl:Set",
  "odrl:permission" : {
    "odrl:target" : "refinery-compressor-2022-01.csv",
```
- Because the policy is embedded in the dataset, you can just remove the faulty `@id` line (then each policy will become a distinct blank node)
- This matches the [DSP spec](https://docs.internationaldataspaces.org/ids-knowledgebase/dataspace-protocol/catalog/catalog.protocol#id-1.1.1-dataset): "A Dataset must have 1..N `hasPolicy` attributes that contain an ODRL Offer"
- On the other hand, the reverse link `target` is wrong: "Offers must NOT contain any explicit target attributes".
  But it does no harm, so you can leave it.
