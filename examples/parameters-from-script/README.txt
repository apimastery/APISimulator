Examples: Parameters from Script
================================

Overview
--------
These examples demonstrate:
- How to configure API Simulation simlets for using the result from 
  executing a script as source for parameters. 
- How the result from executing a script can be used in a matcher.
- Using the result of a script 'eval'-uation as the final value for 
  a parameter.

Take a look the simlet.yaml configuration file in each of the simplets' 
directories to learn about the configuration.


Running the Examples
--------------------
Start the API Simulator locally - follow the online directions. 
For example:
  apisimulator start examples/parameters-from-script
(On Linux, append & at the end to make API Simulator run in the background)

Run the given cURL commands for each of the simlets:

* cookie-parm-matcher (read-profile-123)
  * using cURL:
 curl -v "http://localhost:6090/myProfile" -b "session_id=1.2.588334735.1522417635; profile_id=Profile-123; lang=en"

  * using API Client:
 apiclient -v -h localhost -p 6090 -f "examples/parameters-from-script/tests/read-profile-123.http"


* parm-value-eval (read-profile-456)
  * using cURL:
 curl -v "http://localhost:6090/myProfile" -b "session_id=1.2.588334735.1522417635; profile_id=Profile-456; lang=en"

  * using API Client:
 apiclient -v -h localhost -p 6090 -f "examples/parameters-from-script/tests/read-profile-456.http"
 

Stop the locally running API Simulator - follow the online directions. 
For example:
  apisimulator stop examples/parameters-from-script


Happy API Simulating!
@