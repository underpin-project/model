prefix dspace:       <https://w3id.org/dspace/2024/1/>
prefix edc:          <https://w3id.org/edc/v0.0.1/ns/>

# Add connector Id (after the dot) to the participantId field of Organization and Dataset
# Fix (last row in table)
delete {graph ?g {?x ?prop ?old}}
insert {graph ?g {?x dspace:participantId ?new}}
where {
  values (?old ?new) {
    ("BPNLY38WC4" "BPNLY38WC4.CLEGCS4")
    ("BPNL0C3QGE" "BPNL0C3QGE.CCD3IOO")
    ("BPNLY3SEIW" "BPNLY3SEIW.CV064VJ")
    ("BPNL512R1Q" "BPNL512R1Q.C782W3N")
    ("BPNLJ3NRCO" "BPNLJ3NRCO.CO52UNS") # this is https://demo-connector-1.dataspace.underpinproject.eu, preferred to https://demo-connector-2.dataspace.underpinproject.eu
    ("BPNLRIN7QO" "BPNLOK5DHX.CFXO08H") # Organization Id of SPH was wrong https://github.com/underpin-project/dataspace/issues/63
  }
  values ?prop {edc:participantId dspace:participantId}
  graph ?g {?x ?prop ?old}
};
