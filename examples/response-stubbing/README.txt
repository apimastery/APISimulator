Examples: Response Stubbing
===========================

Overview
--------
These examples demonstrate how to configure an API simulation simlets for returning
stubbed, static response to HTTP requests. 

Some of the examples demonstrate returning responses with binary body payload.   

Running the Examples
--------------------

Start the API Simulator locally - follow the online directions.
For example:
  apisimulator start examples/response-stubbing

Run the given cURL command for each of the simlets:

* binary-base64-body-stub
 curl -v -X GET "http://localhost:6090/stub/conf/logo"
(try the URL also in a browser)

* binary-file-body-stub
 curl -v -X GET "http://localhost:6090/stub/file/logo"
(try the URL also in a browser)

* create-product-1234-stub
 curl -v -X PUT http://localhost:6090/rest/v1/product -H "Content-Type: application/json" -d "{\"product\":{\"id\":\"1234\",\"name\":\"The Jumpers\",\"category\":\"Shoes\",\"subCategory\":\"Basketball\",\"color\":\"white\"}}"

* create-product-5678-stub
 curl -v -X PUT http://localhost:6090/rest/v1/product -H "Content-Type: application/json" -d "{\"product\":{\"id\":\"5678\",\"name\":\"The Rockets\",\"category\":\"Shoes\",\"subCategory\":\"Running\",\"color\":\"white\"}}"

It can be tedious and laborious to have to define a simlet for every possible product id. This is where 
response templating can help.


* xml-body-stub
 curl -v -X GET "http://localhost:6090/api/geolocation/xml?address=100+Pineapple+Parkway,+Alta+Vista,+CA"
(try the URL also in a browser)

* json-body-stub
 curl -v -X GET "http://localhost:6090/api/geolocation/json?address=100+Pineapple+Parkway,+Alta+Vista,+CA"
(try the URL also in a browser)

* _default (404 Not Found)
 curl -v -X GET "http://localhost:6090/images/banner.png"


Stop the locally running API Simulator - follow the online directions. 
For example:
  apisimulator stop examples/response-stubbing


Happy API Simulating!
