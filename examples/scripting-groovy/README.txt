Examples: API Simulator
=======================

Groovy Scripting Overview
-------------------------
The examples below are part of the Groovy scripting simulation. 
They demonstrate the use of Groovy scripts to extend the functionality of API Simulator.

Take a look at the simlet.yaml files to understand how to configure scripting that uses Groovy.

Running the Examples
--------------------
Start the API Simulator locally - follow the online directions. 
For example:
  apisimulator start examples/scripting-groovy

Run the given cURL and/or API Client command for each of the simlets:

* create-payment
This example demonstrates the use of a placeholder which content is produced by Groovy script. 
The script is located in the "scripts" subdirectory under the simulation’s directory.

  * using cURL:
 curl -v "http://localhost:6090/v1/payments" -H "Content-Type: application/json" -d "{ \"intent\":\"sale\", \"payer\":{ \"payment_method\":\"credit_card\", \"funding_instruments\":[ { \"credit_card\":{ \"number\":\"4417119669820331\", \"type\":\"visa\", \"expire_month\":10, \"expire_year\":2017, \"cvv2\":\"748\", \"first_name\":\"Amy\", \"last_name\":\"Cass\", \"billing_address\":{ \"postal_code\":\"59070\", \"country_code\":\"US\" } } } ] }, \"transactions\":[ { \"amount\":{ \"total\":\"18.67\", \"currency\":\"USD\", \"details\":{ \"subtotal\":\"17.41\", \"tax\":\"0.23\", \"shipping\":\"1.03\" } }, \"description\":\"web sale\" } ]}"  
 curl -v "http://localhost:6090/v1/payments" -H "Content-Type: application/json" -d "{ \"intent\":\"sale\", \"payer\":{ \"payment_method\":\"credit_card\", \"funding_instruments\":[ { \"credit_card\":{ \"number\":\"4012888888881881\", \"type\":\"visa\", \"expire_month\":03, \"expire_year\":2019, \"cvv2\":\"930\", \"first_name\":\"Andy\", \"last_name\":\"Smith\", \"billing_address\":{ \"postal_code\":\"66834\", \"country_code\":\"US\" } } } ] }, \"transactions\":[ { \"amount\":{ \"total\":\"422.39\", \"currency\":\"USD\", \"details\":{ \"subtotal\":\"399.99\", \"tax\":\"22.40\" } }, \"description\":\"web sale\" } ]}"  

  * using API Client:
 apiclient -v -h localhost -p 6090 -f "examples/scripting-groovy/tests/create-payment-1.http"
 apiclient -v -h localhost -p 6090 -f "examples/scripting-groovy/tests/create-payment-2.http"


Stop the locally running API Simulator - follow the online directions. 
For example:
  apisimulator stop examples/scripting-groovy


Happy API Simulations!
