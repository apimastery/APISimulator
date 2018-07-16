Examples: API Simulator
=======================

Simulating Latency Overview
---------------------------
The examples below are part of the "latency" simulation. 
They demonstrate the concept of simulating latency in sending the output from a simulation.

Take a look at the simlet.yaml files to understand how to configure latency settings.

Running the Examples
--------------------
Start the API Simulator locally - follow the online directions. 
For example:
  apisimulator start examples/latency

Run the given cURL and/or API Client command for each of the simlets:

* create-product
  * product id = 1234
    * using cURL:
 curl -v -X PUT "http://localhost:6090/v2/products" -H "Content-Type: application/json" -d "{\"product\":{\"id\":\"1234\",\"name\":\"The Jumpers\",\"category\":\"Shoes\",\"subCategory\":\"Basketball\",\"color\":\"white\"}}"    

    * using API Client: 
 apiclient -v -h localhost -p 6090 -f "examples/latency/tests/create-product-1234.http"

  
  * product id = 5678
    * using cURL:
 curl -v -X PUT "http://localhost:6090/v2/products" -H "Content-Type: application/json" -d "{\"product\":{\"id\":\"5678\",\"name\":\"The Rockets\",\"category\":\"Shoes\",\"subCategory\":\"Running\",\"color\":\"white\"}}"    

    * using API Client: 
 apiclient -v -h localhost -p 6090 -f "examples/latency/tests/create-product-5678.http"


* get-product-1234
  * using cURL:
 curl -v -X GET "http://localhost:6090/v2/products/1234/details.json"    

  * using API Client: 
 apiclient -v -h localhost -p 6090 -f "examples/latency/tests/get-product-1234.http"


Stop the locally running API Simulator - follow the online directions.
For example:
  apisimulator stop examples/latency


Happy API Simulations!
