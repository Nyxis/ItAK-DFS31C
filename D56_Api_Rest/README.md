# Weather API Integration Project

This project demonstrates the integration of OpenWeatherMap and OpenStreetMap APIs to provide weather and location information through a secure REST API.

## Features

- Fetch current weather data for a given latitude/longitude or city name
- Retrieve location information for coordinates
- Combine weather and location data into a single response
- Support for different output formats (JSON, XML, CSV)
- Secure authentication using API key and HMAC signatures

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

   To obtain an OpenWeatherMap API key:
    - Sign up for a free account at [OpenWeatherMap](https://home.openweathermap.org/users/sign_up)
    - Once logged in, go to your [API keys](https://home.openweathermap.org/api_keys) page
    - Copy your API key and paste it into the `.env` file

## Usage

1. Start the server:
   ```
   npm start
   ```

2. Use the provided CLI tool to test the API:
   ```
   node cli.js <location> <api_key> <secret>
   ```

   Where:
    - `<location>` can be a city name (e.g., "London") or coordinates (e.g., "40.7128,-74.0060")
    - `<api_key>` is your API key (use "sample_key" for testing)
    - `<secret>` is your secret for generating HMAC signatures (use "sample_secret" for testing)

   Examples:
   ```
   node cli.js London sample_key sample_secret
   node cli.js 40.7128,-74.0060 sample_key sample_secret
   ```

3. Access the API endpoints directly:
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

   Note: When accessing endpoints directly, you need to include the API key and HMAC signature in the headers:
    - `x-api-key`: Your API key
    - `x-api-signature`: HMAC signature (see API documentation for details on generating the signature)

## Running Tests

To run the integration tests:

```
npm test
```

## API Documentation

For detailed API usage and endpoint information, please refer to the [API Documentation](API_Documentation.md) file.

### Key Endpoints

1. GET /api/v1/location-weather
    - Retrieves weather and location data for given coordinates or city name.
    - Query Parameters: `lat` & `lon` (for coordinates) or `city` (for city name)

2. GET /api/v1/format/:format
    - Returns a simple "hello world" message in the specified format.
    - Path Parameters: `format` (can be "json", "xml", or "csv")

## Security

This API uses two forms of authentication:
1. API Key: Required for all requests (sent in the `x-api-key` header).
2. HMAC Signature: Required for all requests (sent in the `x-api-signature` header).

For testing purposes, use:
- API Key: `sample_key`
- Secret for HMAC: `sample_secret`

In a production environment, these should be securely managed and distributed.

## Troubleshooting

- If you encounter CORS issues while testing, ensure you're using the correct protocol (http/https) and port.
- Verify that your OpenWeatherMap API key is correctly set in the `.env` file.
- Check that you're sending the correct API key and HMAC signature in the headers for all requests.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Acknowledgments

- OpenWeatherMap for providing weather data
- OpenStreetMap for geocoding services

