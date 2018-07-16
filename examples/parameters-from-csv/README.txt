Examples: Parameters from CSV Source
====================================

Overview
--------
These examples demonstrate how to configure API Simulation simlets for 
using CSV (comma-separated values) source for parameters.
 
Take a look the simlet.yaml configuration file in each of the simplets' 
directories to learn about the configuration.


Running the Examples
--------------------
Start the API Simulator locally - follow the online directions. 
For example:
  apisimulator start examples/parameters-from-csv
(On Linux, append & at the end to make API Simulator run in the background)

Run the given cURL commands for each of the simlets:

* read-product-from-file
 curl -v -X GET "http://localhost:6090/v1.1/product/2706414/Solid+Gray/S"
 curl -v -X GET "http://localhost:6090/v1.1/product/2706414/Solid+Gray/XL"
 curl -v -X GET "http://localhost:6090/v1.1/product/2706414/Black+Charcoal/XL"


* missing-product-from-file
 curl -v -X GET "http://localhost:6090/v1.1/product/9999999/Solid+Gray/XL"
 curl -v -X GET "http://localhost:6090/v1.1/product/2706414/Solid+Gray/2XL"


* read-product-from-config
 curl -v -X GET "http://localhost:6090/v1.2/product/2706414/Solid+Gray/S"
 curl -v -X GET "http://localhost:6090/v1.2/product/2706414/Solid+Gray/XL"
 curl -v -X GET "http://localhost:6090/v1.2/product/2706414/Black+Charcoal/XL"


* missing-product-from-config
 curl -v -X GET "http://localhost:6090/v1.2/product/9999999/Solid+Gray/XL"
 curl -v -X GET "http://localhost:6090/v1.2/product/2706414/Solid+Gray/2XL"


* _default (404 Not Found)
 curl -v -X GET "http://localhost:6090/v1/product/9999"


Stop the locally running API Simulator - follow the online directions. 
For example:
  apisimulator stop examples/parameters-from-csv


Happy API Simulations!
@