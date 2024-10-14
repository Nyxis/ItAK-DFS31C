# Weather API Integration Project

This project demonstrates the integration of OpenWeatherMap and OpenStreetMap APIs to provide weather and location information.

## Features

- Fetch current weather data for a given latitude and longitude
- Retrieve location information for coordinates
- Combine weather and location data into a single response
- Support for different output formats (JSON, XML, CSV)

## Prerequisites

- Node.js (version 14 or higher)
- npm (Node Package Manager)
- OpenWeatherMap API key (free tier)

## Installation

1. Clone the repository:
   ```
   git clone https://github.com/your-username/weather-api-integration.git
   cd weather-api-integration
   ```

2. Install dependencies:
   ```
   npm install
   ```

3. Create a `.env` file in the root directory and add your OpenWeatherMap API key:
   ```
   OPENWEATHERMAP_API_KEY=your_api_key_here
   ```

## Usage

1. Start the server:
   ```
   npm start
   ```

2. Access the API endpoints:
   - Get weather and location data:
     ```
     http://localhost:3000/api/v1/location-weather?lat=40.7128&lon=-74.0060
     ```
   - Get data in different formats:
     ```
     http://localhost:3000/api/v1/format/json
     http://localhost:3000/api/v1/format/xml
     http://localhost:3000/api/v1/format/csv
     ```

## Running Tests

To run the integration tests:

```
npm test
```

## API Documentation

### GET /api/v1/location-weather

Retrieves weather and location data for given coordinates.

Query Parameters:
- `lat`: Latitude (required)
- `lon`: Longitude (required)

Example Response:
```json
{
  "locationName": "New York City Hall, 260, Broadway, Lower Manhattan, Civic Center, Manhattan, New York County, City of New York, New York, 10000, United States",
  "latitude": 40.7128,
  "longitude": -74.006,
  "cityName": "City of New York",
  "country": "United States",
  "temperature": 11.86,
  "humidity": 87,
  "windSpeed": 1.34,
  "timestamp": "2024-10-14T12:34:56.789Z"
}
```

### GET /api/v1/format/:format

Returns a simple "hello world" message in the specified format.

Path Parameters:
- `format`: Can be "json", "xml", or "csv"

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.
