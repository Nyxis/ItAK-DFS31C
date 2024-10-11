# Format API Documentation

## Endpoints

1. `GET /api/v1/format/json`
2. `GET /api/v1/format/xml`
3. `GET /api/v1/format/csv`

## Description

These endpoints return a "hello world" message in different formats based on the specific route accessed.

## Responses

1. JSON Format: `/api/v1/format/json`
    - Returns JSON: `{"hello": "world"}`
    - Content-Type: application/json

2. XML Format: `/api/v1/format/xml`
    - Returns XML: `<hello>world</hello>`
    - Content-Type: application/xml

3. CSV Format: `/api/v1/format/csv`
    - Returns CSV: `hello\nworld\n`
    - Content-Type: text/csv

## Status Codes

- 200 OK: Successful request

## Examples

### JSON

```
GET /api/v1/format/json

Response:
Status: 200 OK
Content-Type: application/json

{"hello": "world"}
```

### XML

```
GET /api/v1/format/xml

Response:
Status: 200 OK
Content-Type: application/xml

<hello>world</hello>
```

### CSV

```
GET /api/v1/format/csv

Response:
Status: 200 OK
Content-Type: text/csv

hello
world
```
# Format API Documentation

[... previous content remains the same ...]

## New Endpoints

### `GET /api/v1/location-weather`

Returns location and weather information for a given place.

#### Request Parameters

- `lat`: Latitude of the location (float)
- `lon`: Longitude of the location (float)

#### Response

Returns a JSON object with the following structure:

```json
{
  "location": {
    "name": "string",
    "latitude": float,
    "longitude": float,
    "city": "string",
    "country": "string"
  },
  "weather": {
    "temperature": float,
    "humidity": float,
    "windSpeed": float
  },
  "timestamp": "ISO8601 string"
}
```

#### Status Codes

- 200 OK: Successful request
- 400 Bad Request: Invalid parameters
- 404 Not Found: Location not found
- 500 Internal Server Error: Error fetching weather data

## Data Models

### Location (Value Object)
- name: string
- coordinates: GPS (Value Object)
- city: City (Value Object)
- country: string

### GPS (Value Object)
- latitude: float
- longitude: float

### City (Value Object)
- name: string

### WeatherData (Value Object)
- temperature: float
- humidity: float
- windSpeed: float

### LocationWeatherData (DTO)
- location: Location
- weather: WeatherData
- timestamp: Date

## Versioning
This API follows Semantic Versioning. The current version is v1. Any breaking changes will be introduced in a new major version (e.g., v2).
