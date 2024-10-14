# Weather API Documentation

## Base URL

All URLs referenced in the documentation have the following base:

```
http://localhost:3000/api/v1
```

## Authentication

This API uses two forms of authentication:

1. API Key: Required for all requests.
2. HMAC Signature: Required for all requests.

### API Key

Include your API key in the `x-api-key` header of all requests.

### HMAC Signature

For all queries, generate an HMAC-SHA256 signature using the query parameters, and include it in the `x-api-signature` header.

Signature generation (pseudo-code):
```
// For city-based queries
data = "city=" + cityName

// For coordinate-based queries
data = "lat=" + latitude + "&lon=" + longitude

signature = HMAC-SHA256(data, secret)
```

## Endpoints

### 1. GET /

Returns available endpoints and API information.

#### Request

```
GET /
```

#### Headers

- `x-api-key`: Your API key
- `x-api-signature`: HMAC signature

#### Query Parameters

- `lat` and `lon` (required for coordinate-based queries): Latitude and longitude of the location
- `city` (required for city-based queries): Name of the city

#### Response

- **Status Code**: 200 OK
- **Content-Type**: application/json

```json
{
  "version": "v1",
  "availableEndpoints": [
    {
      "name": "Get Weather Data",
      "method": "GET",
      "link": "http://localhost:3000/api/v1/location-weather?lat={latitude}&lon={longitude}",
      "description": "Get weather information for a given location"
    }
  ]
}
```

### 2. GET /location-weather

Returns weather information for a given location.

#### Request

```
GET /location-weather
```

#### Headers

- `x-api-key`: Your API key
- `x-api-signature`: HMAC signature

#### Query Parameters

- `lat` and `lon` (required for coordinate-based queries): Latitude and longitude of the location
- `city` (required for city-based queries): Name of the city

#### Response

- **Status Code**: 200 OK
- **Content-Type**: application/json

```json
{
  "locationName": "New York",
  "latitude": 40.7128,
  "longitude": -74.006,
  "cityName": "New York",
  "country": "US",
  "temperature": 14.76,
  "humidity": 81,
  "windSpeed": 2.57,
  "timestamp": "2024-10-14T14:13:54.561Z"
}
```

#### Error Responses

1. Invalid API key:
   - **Status Code**: 401 Unauthorized
   ```json
   {"error": "Unauthorized: Invalid API key"}
   ```

2. Invalid signature:
   - **Status Code**: 401 Unauthorized
   ```json
   {"error": "Unauthorized: Invalid signature"}
   ```

3. Invalid latitude (not between -90 and 90):
   - **Status Code**: 400 Bad Request
   ```json
   {"error": "Invalid latitude. Must be a number between -90 and 90."}
   ```

4. Invalid longitude (not between -180 and 180):
   - **Status Code**: 400 Bad Request
   ```json
   {"error": "Invalid longitude. Must be a number between -180 and 180."}
   ```

5. Invalid city name:
   - **Status Code**: 400 Bad Request
   ```json
   {"error": "Invalid city name or failed to fetch location data."}
   ```

6. Missing required parameters:
   - **Status Code**: 400 Bad Request
   ```json
   {"error": "You must provide either a city name or latitude and longitude."}
   ```

## Rate Limiting

Currently, there is no rate limiting implemented. Please use the API responsibly.

## Data Sources

This API uses OpenStreetMap for geocoding and OpenWeatherMap for weather data.

