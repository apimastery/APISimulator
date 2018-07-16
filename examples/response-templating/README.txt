Examples: Response Templating
=============================

Overview
--------
These examples demonstrate how to configure API Simulation simlets for 
returning dynamic responses produced as result of rendering a template. 

Some of the examples demonstrate returning responses with binary body payload.   

Take a look the simlet.yaml configuration file in each of the simplets' 
directories to learn about the configuration.


Running the Examples
--------------------

Start the API Simulator locally - follow the online directions. 
For example:
  apisimulator start examples/response-templating

Run the given cURL command for each of the simlets:

* binary-body-base64
 curl -v -X GET "http://localhost:6090/template/conf/logo"
(try the URL also in a browser)


* binary-body-file
 curl -v -X GET "http://localhost:6090/template/file/logo"
(try the URL also in a browser)


* conditional-header
 curl -v -X GET "http://localhost:6090/api/places/nearby?postalCode=12123&radius=9&placeType=restaurant" -H "Origin: http://apisimulation.com"


* create-product
  * product id = 1234
 curl -v -X PUT "http://localhost:6090/rest/v2/product" -H "Content-Type: application/json" -d "{\"product\":{\"name\":\"The Jumpers\",\"category\":\"Shoes\",\"subCategory\":\"Basketball\",\"id\":\"1234\",\"color\":\"white\"}}"

  * product id = 5678
 curl -v -X PUT "http://localhost:6090/rest/v2/product" -H "Content-Type: application/json" -d "{\"product\":{\"id\":\"5678\",\"name\":\"The Rockets\",\"category\":\"Shoes\",\"subCategory\":\"Running\",\"color\":\"white\"}}"

  *  product id = 9876
 curl -v -X PUT "http://localhost:6090/rest/v2/product" -H "Content-Type: application/json" -d "{\"product\":{\"id\":\"9876\",\"name\":\"Another product\"}}"


* create-product-no-name
 curl -v -X PUT "http://localhost:6090/rest/v2/product" -H "Content-Type: application/json" -d "{\"product\":{\"id\":\"1234\",\"category\":\"Shoes\",\"subCategory\":\"Basketball\",\"color\":\"white\"}}"


* format-and-encode
 curl -v -X POST "http://localhost:6090/v3/products" -H "Content-Type: application/json" -d "{\"product\":{\"id\":\"9999456789\",\"name\":\"new-name\",\"update_ts\":\"2018-01-03 16:58:01 UTC\"}}"


* nondefault-delimiters
 curl -v -X GET "http://localhost:6090/api/places/nearby?postalCode=11223&radius=8&placeType=restaurant&debug"


* param-time-dependency
 curl -v -X GET "http://localhost:6090/api/places/json?postalCode=45456&radius=5&types=food"


* params-random
 curl -v -X GET "http://localhost:6090/api/places/nearby?postalCode=34345&radius=6&types=food"


* params-request-line
 curl -v -X GET "http://admin:passW0rd@localhost:6090/v1/products/2706414/Black+Charcoal/XL?p1=4&p2=restaurant%26bar&p2=cafe&checked#ref1"
(Notice that cURL converts the user info into a Basic Auth header, uses the 
 host and port in a Host header, and drops the "ref1" fragment)


* placeholder-complex
 curl -v -X GET "http://localhost:6090/api/places/nearby?postalCode=12345&radius=10&placeType=restaurant&placeType=cafe&debug"


* scriptlets
 curl -v -X GET "http://localhost:6090/api/places/nearby?postalCode=54321&radius=10&placeType=restaurant&placeType=cafe&debug"


* text-body-file
 curl -v -X POST "http://localhost:6090/v1/payments/payment" -H "Content-Type: application/json" -d "{ \"intent\":\"sale\", \"payer\":{ \"payment_method\":\"credit_card\", \"funding_instruments\":[ { \"credit_card\":{ \"number\":\"4417119669820331\", \"type\":\"visa\", \"expire_month\":10, \"expire_year\":2017, \"cvv2\":\"748\", \"first_name\":\"Amy\", \"last_name\":\"Cass\", \"billing_address\":{ \"postal_code\":\"59070\", \"country_code\":\"US\" } } } ] }, \"transactions\":[ { \"amount\":{ \"total\":\"18.67\", \"currency\":\"USD\", \"details\":{ \"subtotal\":\"17.41\", \"tax\":\"0.23\", \"shipping\":\"1.03\" } }, \"description\":\"web sale\" } ]}"


* text-body-config
 curl -v -X POST "http://localhost:6090/v2/payments/payment" -H "Content-Type: application/json" -d "{ \"intent\":\"sale\", \"payer\":{ \"payment_method\":\"credit_card\", \"funding_instruments\":[ { \"credit_card\":{ \"number\":\"4417119669820331\", \"type\":\"visa\", \"expire_month\":10, \"expire_year\":2017, \"cvv2\":\"748\", \"first_name\":\"Amy\", \"last_name\":\"Cass\", \"billing_address\":{ \"postal_code\":\"59070\", \"country_code\":\"US\" } } } ] }, \"transactions\":[ { \"amount\":{ \"total\":\"18.67\", \"currency\":\"USD\", \"details\":{ \"subtotal\":\"17.41\", \"tax\":\"0.23\", \"shipping\":\"1.03\" } }, \"description\":\"web sale\" } ]}"


* _default (404 Not Found)
 curl -v -X GET "http://localhost:6090/images/banner.png"


Stop the locally running API Simulator - follow the online directions. 
For example:
  apisimulator stop examples/response-templating


Happy API Simulations!
