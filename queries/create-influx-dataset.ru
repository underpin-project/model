PREFIX rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX dspace: <https://w3id.org/dspace/2024/1/>
PREFIX dct: <http://purl.org/dc/terms/>
BASE <https://dataspace.underpinproject.eu/>
PREFIX dcat: <http://www.w3.org/ns/dcat#>
construct {
    ?influx_uri
        a dcat:Dataset, dcat:DatasetSeries ;
        dct:identifier ?influx_id ;
        dct:spactial ?influx_spatial_uri ;
        dct:temporal ?influx_temporal_uri ;
        dcat:distribution ?influx_distribution_uri ;
        dct:conformsTo ?schema ;
        dct:title ?influx_title ;
        dspace:participantId ?participantId ;
        dcat:keyword ?keyword ;
    .
    ?influx_spatial_uri ?spatial_p ?spatial_o .
    ?influx_temporal_uri ?temporal_p ?temporal_o .

    ?influx_distribution_uri
        a dcat:Distribution ;
        dct:format 'application/x-influx' .

    ?s_dataset dcat:inSeries ?influx_uri .
}
where {
#     bind('refinery-compressor-user-id' as ?influx_id_user)
#     bind('refinery-compressor-user-title' as ?influx_title_user)

    bind(<dataset/windfarm-WF1-WTG01-2020.csv> as ?s_dataset)
    ?s_dataset
        dct:identifier ?s_id ;
    dct:title ?s_title ;
    dct:publisher ?pub ;
    dct:conformsTo ?schema ;
    dspace:participantId ?participantId ;
    .
    bind(if(bound(?influx_id_user),?influx_id_user,replace(?s_id,'.csv','-influx')) as ?influx_id)
    bind(uri(concat('dataset/',str(?influx_id))) as ?influx_uri)
    bind(if(bound(?influx_title_user),?influx_title_user,replace(?s_title,'as csv','as influx')) as ?influx_title)
    optional {
        ?s_dataset   dct:temporal ?s_temporal .
        ?s_temporal ?temporal_p ?temporal_o .
        bind(uri(concat(str(?influx_id),"/temporal")) as ?influx_temporal_uri)
    }
    optional {
        ?s_dataset dct:spatial ?s_spatial .
        ?s_spatial ?spatial_p ?spatial_o .
        bind(uri(concat(str(?influx_id),"/spatial")) as ?influx_spatial_uri)
    }
    bind(uri(concat(str(?influx_id),"/distribution")) as ?influx_distribution_uri)
    optional {
        ?s_dataset dcat:keyword ?keyword
    }
}
