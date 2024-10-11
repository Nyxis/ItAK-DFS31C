# Format API Documentation

## Base URL

All URLs referenced in the documentation have the following base:

```
http://localhost:3000/api/v1
```

## Endpoints

1. [GET /format/json](#1-get-formatjson)
2. [GET /format/xml](#2-get-formatxml)
3. [GET /format/csv](#3-get-formatcsv)
4. [GET /location-weather](#4-get-location-weather)

---

### 1. GET /format/json

Returns a simple JSON object.

#### Request

```
GET /format/json
```

#### Response

- **Status Code**: 200 OK
- **Content-Type**: application/json

```json
{
  "hello": "world"
}
```

---

### 2. GET /format/xml

Returns a simple XML structure.

#### Request

```
GET /format/xml
```

#### Response

- **Status Code**: 200 OK
- **Content-Type**: application/xml

```xml
<hello>world</hello>
```

---

### 3. GET /format/csv

Returns a simple CSV format.

#### Request

```
GET /format/csv
```

#### Response

- **Status Code**: 200 OK
- **Content-Type**: text/csv

```
hello
world
```

---

### 4. GET /location-weather

Returns weather information for a given location.

#### Request

```
GET /location-weather?lat={latitude}&lon={longitude}
```

#### Query Parameters

- `lat` (required): Latitude of the location (float between -90 and 90)
- `lon` (required): Longitude of the location (float between -180 and 180)

#### Response

- **Status Code**: 200 OK
- **Content-Type**: application/json

```json
{
  "locationName": "Mock Location",
  "latitude": 40.7128,
  "longitude": -74.0060,
  "cityName": "MockCity",
  "country": "MockCountry",
  "temperature": 25.5,
  "humidity": 60,
  "windSpeed": 10,
  "timestamp": "2024-10-11T12:00:00Z"
}
```

#### Error Responses

1. Missing both latitude and longitude:
   - **Status Code**: 400 Bad Request
   ```json
   {"error": "Both latitude and longitude are required"}
   ```

2. Missing latitude:
   - **Status Code**: 400 Bad Request
   ```json
   {"error": "Latitude is required"}
   ```

3. Missing longitude:
   - **Status Code**: 400 Bad Request
   ```json
   {"error": "Longitude is required"}
   ```

4. Invalid latitude (not between -90 and 90):
   - **Status Code**: 400 Bad Request
   ```json
   {"error": "Invalid latitude. Must be a number between -90 and 90."}
   ```

5. Invalid longitude (not between -180 and 180):
   - **Status Code**: 400 Bad Request
   ```json
   {"error": "Invalid longitude. Must be a number between -180 and 180."}
   ```

## Data Models

### LocationWeatherData (DTO)

- `locationName`: string
- `latitude`: float
- `longitude`: float
- `cityName`: string
- `country`: string
- `temperature`: float
- `humidity`: float
- `windSpeed`: float
- `timestamp`: string (ISO8601 format)

## Versioning

This API follows Semantic Versioning. The current version is v1. Any breaking changes will be introduced in a new major version (e.g., v2).

