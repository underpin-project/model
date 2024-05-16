# Model

## Categiories

Categories mapped to QUDT [quantity kind](https://www.qudt.org/doc/DOC_VOCAB-QUANTITY-KINDS.html)

| value               | qudt                         | comment                                                        |
|---------------------|------------------------------|----------------------------------------------------------------|
| AXIAL  DISPLACEMENT | ???                          | 
| CURRENT             | quantitykind:TotalCurrent    |                                                                | 
| FLOW                | quantitykind:MassFlowRate    |                                                                | 
| PRESSURE            | quantitykind:DynamicPressure |                                                                | 
| speed               |                              | this is actually turbine rotation  `quantitykind:Speed` is NOK |  
| TEMPERATURE         | quantitykind:Temperature     |                                                                | 
| VIBRATION           | ??                           |                                                                | 


## Units

Units mapped to [units](https://www.qudt.org/doc/DOC_VOCAB-UNITS.html)

| value   | qudt                        |                             | 
|---------|-----------------------------|-----------------------------|
| Ampere  | unit:A                      |                             |
| degC    | unit:DEG_C                  |                             |
| Kg/cm2  | unit:KiloGM_F-PER-CentiM2   | also present in lc (kg/cm2) |
| Kgf/cm2 | unit:KiloGM_F-M-PER-CentiM2 |                             |
| Kg/h    | unit:KiloGM-PER-HR          |                             |
| micron  | unit:MicroM                 |                             |
| mm      | unit:MilliM                 |                             |
| rpm     | unit:REV-PER-MIN            |                             |


# Links

[Data samples](https://motoroil.sharepoint.com/:f:/r/sites/UNDERPIN/Shared%20Documents/General/2.%20WPs/WP4-Use-cases/01.%20Data%20samples/01.%20Refinery%20data?csf=1&web=1&e=fdrc2L) 
on project teams. 

# Questions

How to model threshholds ?
How to model and aggrgation rules?
Equipment ids are almost redundant. Not sure what's going on there
* same `K-2201/KT-2201`
* same `K-3301 B/KT-3301 B`
* not same `K-7502/ST-7501`

