# Wind Farm Data Model

This model describes a semantic mapping for 3  data sources.
Links to sample data are on google drive.

## Sensor Data
[WF1_WGT01 - Row Data_Logs.xlsx](https://docs.google.com/spreadsheets/d/1bKZlcDIDZLF6biRiPdkgMAIKOaVn1PuO/) contains data from one turbine 
* sheet `data` has raw time series data from 132 sensors
* sheet `logs` has log entries 

## Alert Events
[Event Logs - Case 1](https://docs.google.com/spreadsheets/d/1ebEnlE-B7WI8Gzfc-fV6vvkmZ8GAu4K1)
Contains alert events.
They have a similar structure like logs, but use different identifiers and categories.

| System | Timestamp    | Status | Name      | Description                         | Category | Event Type            | Power (kW) | Wind Speed (m/s) | Gen. Speed (Rpm) | CCU Event |
|--------|--------------|--------|-----------|-------------------------------------|----------|-----------------------|------------|------------------|------------------|-----------|
| WTG1   | 3/3/22 16:57 | ON     | EVENT_014 | Generator Overspeed First Threshold | Multiple | Safety Critical fault |      -6.02 |            12.25 |          1821.09 | No        |
| WTG1   | 3/3/22 17:28 | OFF    | EVENT_014 | Generator Overspeed First Threshold | Multiple | Safety Critical fault |      -2.27 |            11.49 |            46.93 | No        |

The model currently uses the [W3C Cube ontology](https://www.w3.org/TR/vocab-data-cube/) to represent timeseries directly in RDF.
- Please note that this is not the final version.
- The current thinking is to use a timeseries database and only keep semantic description

### Model

Diagram generated from [wt-events.ttl](wt-events.ttl):

![](wt-events.png)

Legend:
- red: project-specific readings
- pink: W3C CUBE definitions: `DataStructureDefinition` and properties
- yellow: thesauri (`ConceptSchemes`) and nomenclature values (`Concept`)

Overview:
- The `Observation` carries all project-specific measurements (`MeasureProperty`),
  and a standard timestamp prop `timePeriod` (which is `DimensionProperty`)
- The `Dataset` holds observations having the same structure,
  and points to the equipment being observed (`hasFeatureOfInterest`)
- The `DataStructureDefinition` defines what props are expected in each observation
- Numeric `MeasureProperties` specify what it is (`QuantityKind`)
  and what `unitMeasure` it uses (`Unit`),
  leveraging a standard ontology.
- Conceptual `MeasureProperties` (`event`) specify concepts from which `ConceptScheme` they use as values
  (in this case an enumeration of events)


### Fixes

- Defined a `@base`
- Removed empty prefix `:`
- Sorted and aligned prefixes
- Fixed `genSpeed` description
- Fixed "seconds" in timestamps to "00" as I think that's more natural than "59"
- Removed the "parasitic" last part ("seconds") from URLs ("59" or "00") since it's not in the data
- Consistently used 2 spaces to indent
- Put all props in a single namespace rather than subnamespaces like `<dim/power>`
- Renamed `<eventType>` to `severity` because that reflects better its nature.
- Parsed event names to capture their nature in a semantic way. 
  Examples of props that can be extracted:
  - "Generator Overspeed First Threshold"
    - Subject (equipment/component): Generator (TODO: relate to Wind Farm ontology)
    - Problem: Overspeed
    - Threshold: 1
  - "Battery charging voltage not OK Axis3"
    - Subject (equipment/component): Battery 
    - Property: charging voltage
    - Axis: 3 (TODO: what is this?)
    - (Problem "not OK" is generic, so not captured)
  - "Malfunction Triplepitch System Axis 3"
    - Subject (equipment/component): Triplepitch System
    - Axis: 3
    - (Problem "Malfunction" is generic, so not captured)

### Questions

Clarifications and fixes needed:

- Maybe we need to remodel this as Events rather than Observations,
  because I think the table captures two parallel streams of info:
  alarm events (primary), and important background variables (power, wind speed, generator speed)
- Understand what is `<category>` ("multiple"??)
- Turn `subject, category, severity, problem` into thesauri rather than strings
- What is "Opened Safety Chain"? Appears in many events
