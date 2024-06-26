# Wind farm data model

Three data soruces

[WF1_WGT01 - Row Data_Logs.xlsx](https://docs.google.com/spreadsheets/d/1bKZlcDIDZLF6biRiPdkgMAIKOaVn1PuO/) contains data from one turbine 
* sheet `data` the raw time series data from 132 sensors
* sheet `logs` contains log entries 

[Event Logs - Case 1](https://docs.google.com/spreadsheets/d/1ebEnlE-B7WI8Gzfc-fV6vvkmZ8GAu4K1)
Contains events,
They are of a similar structure as logs but with different identifiers and categories

| System  | 	Timestamp | Status | Name      | Description                          | Category | Event Type             | Power (kW) | Wind Speed (m/s)  | Gen. Speed (Rpm) | CCU Event |
|-------|----------------|--------|-----------|--------------------------------------|----------|------------------------|------------|-------------------|------------------|----------| 
| WTG1	  | 3/3/22 16:57  | ON     | EVENT_014 | Generator Overspeed First Threshold  | Multiple | 	Safety Critical fault | -6.02      | 	12.25           | 	1821.09	      | No       |
| WTG1	  | 3/3/22 17:28  | OFF    | EVENT_014 | Generator Overspeed First Threshold  | Multiple | 	Safety Critical fault | -2.27      | 	11.49           |  	46.93         | No       |




