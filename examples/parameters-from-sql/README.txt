Examples: Parameters from SQL Data Store
========================================

Overview
--------
These examples demonstrate how to configure API Simulation simlets for 
using SQL data store (e.g. RDBMS) for parameters.
 
Take a look the simlet.yaml configuration file in each of the simplets' 
directories to learn about the configuration.


Running the Examples
--------------------
Start the API Simulator locally - follow the online directions. 
For example:
  apisimulator start examples/parameters-from-sql
(On Linux, append & at the end to make API Simulator run in the background)

Run the given cURL commands for each of the simlets:

* read-product
 curl -v -X GET "http://localhost:6090/v1.1/product/2706414/Solid+Gray/S"
 curl -v -X GET "http://localhost:6090/v1.1/product/2706414/Solid+Gray/XL"
 curl -v -X GET "http://localhost:6090/v1.1/product/2706414/Black+Charcoal/XL"


* product-not-found
 curl -v -X GET "http://localhost:6090/v1.1/product/9999999/Solid+Gray/XL"
 curl -v -X GET "http://localhost:6090/v1.1/product/2706414/Solid+Gray/2XL"


* _default (404 Not Found)
 curl -v -X GET "http://localhost:6090/v1/product/9999"


Stop the locally running API Simulator - follow the online directions. 
For example:
  apisimulator stop examples/parameters-from-sql


Happy API Simulating!
@