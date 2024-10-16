API Exercise Documentation

Part 1: JSON/XML/CSV API

Overview

This part of the project is a basic Node.js API that returns different data formats (JSON, XML, CSV). The API is versioned, and the current version is V1.

API Routes

1. /APIexercice/V1/json

	•	Description: Returns a simple JSON object with the message "hello": "world".
	•	Response:

{
  "hello": "world"
}



2. /APIexercice/V1/xml

	•	Description: Returns a simple XML response with <hello>world</hello>.
	•	Response:

<hello>world</hello>



3. /APIexercice/V1/csv

	•	Description: Returns a CSV string with two lines: "hello" and "world".
	•	Response:

hello
world



Error Handling

	•	404 Not Found: When accessing routes that don’t exist, the API returns a 404 response.
	•	500 Internal Server Error: Handles unexpected errors in the routes, returning an appropriate message.

Folder Structure

Controllers

	•	jsonController.js: Contains the logic for handling /json route requests.
	•	xmlController.js: Handles the logic for the /xml route.
	•	csvController.js: Manages the logic for the /csv route.

Routes

	•	json.js: Maps the /json route to the jsonController.
	•	xml.js: Maps the /xml route to the xmlController.
	•	csv.js: Maps the /csv route to the csvController.

index.js

	•	Sets up the server and imports all routes.
	•	The root endpoint (/) displays a homepage with buttons linking to each available route.

How to Run

	1.	Install dependencies:

npm install


	2.	Start the server:

node index.js


	3.	Access the API:
	•	Navigate to http://localhost:3000 for the homepage, or directly access:
	•	JSON: http://localhost:3000/APIexercice/V1/json
	•	XML: http://localhost:3000/APIexercice/V1/xml
	•	CSV: http://localhost:3000/APIexercice/V1/csv

How to Add New Versions

	1.	Create new route and controller files under the version folder (e.g., V2).
	2.	Update index.js to include the new version.
	3.	Ensure all new routes have the correct version in their URL prefixes (e.g., /APIexercice/V2/...).

Part 2: Weather API & CLI

Overview

The second part of the project involves a weather API that retrieves weather data based on city name or GPS coordinates (latitude and longitude) by connecting to the OpenWeather API. This section also includes security using JWT (JSON Web Tokens) for authentication, and a command-line interface (CLI) to interact with the API.

API Routes

1. /APIexercice/V1/auth

	•	Description: Generates a JWT token when provided with the correct API and Secret keys.
	•	Method: POST
	•	Body (example):

{
  "providedApiKey": "your_api_key",
  "providedSecretKey": "your_secret_key"
}


	•	Response:

{
  "token": "your_jwt_token"
}


	•	Error Response:
	•	401 Unauthorized: Returned when the API key or secret key is invalid.
	•	Example:

{
  "error": "Invalid API key or secret key"
}



2. /APIexercice/V1/locationWeatherData

	•	Description: Retrieves weather data for a city or GPS coordinates.
	•	Method: GET
	•	Query Parameters:
	•	city: City name (optional if lat/lon is provided).
	•	lat: Latitude (optional if city is provided).
	•	lon: Longitude (optional if city is provided).
	•	Headers: Requires the Authorization: Bearer <token> header with the JWT token.
	•	Response (example for city query):

{
  "city": "Lyon",
  "country": "France",
  "latitude": "45.7578137",
  "longitude": "4.8320114",
  "temperature": 22.98,
  "weatherDescription": "clear sky",
  "windSpeed": 4.63,
  "humidity": 70
}



CLI Tool

A simple command-line interface (CLI) tool has been built to interact with the weather API. The CLI supports querying by city or GPS coordinates.

CLI Commands

1. weather --auth

	•	Description: Generates and retrieves an API token using the .env values for API_KEY and SECRET_KEY.
	•	Usage:

weather --auth



2. weather --city <city_name>

	•	Description: Fetches weather data for a specified city.
	•	Usage:

weather --city Paris



3. weather --lat <latitude> --lon <longitude>

	•	Description: Fetches weather data for the specified GPS coordinates.
	•	Usage:

weather --lat 48.8566 --lon 2.3522



4. weather --help

	•	Description: Displays the help information for the CLI tool.
	•	Usage:

weather --help



CLI Error Handling

	•	Invalid City/GPS: If invalid city or GPS coordinates are provided, the CLI will return an error message.
	•	Missing Token: If the token is missing or expired, an error message will prompt the user to re-authenticate using weather --auth.
	•	Invalid API Key or Secret: If the .env keys are incorrect or missing, an error will be shown during token generation.

How to Run the CLI

	1.	Install dependencies:

npm install


	2.	Generate an API Token:

weather --auth


	3.	Query Weather Data by City:

weather --city Paris


	4.	Query Weather Data by GPS Coordinates:

weather --lat 48.8566 --lon 2.3522



How to Add More Endpoints

	1.	Define new services in services/.
	2.	Create new route controllers in controllers/ for the required endpoints.
	3.	Add the new routes to the router file under routes/ and map them to the controller functions.

Environment Variables

The API requires the following .env file setup:

OPENWEATHER_API_KEY=<your_openweather_api_key>
API_KEY=<your_generated_api_key>
SECRET_KEY=<your_generated_secret_key>

Future Enhancements

	•	Multiple Versions: Add the ability to handle future API versions seamlessly.
	•	Expand Hypermedia: Improve the homepage to expose more API links.
	•	Enhanced Security: Add rate limiting, IP filtering, and refresh tokens for better security.
	•	Advanced CLI Features: Add additional features like weather history, forecast data, and batch queries.
