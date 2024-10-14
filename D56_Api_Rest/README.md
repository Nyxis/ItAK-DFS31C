# D56 - Concevoir / Créer / Consommer des Apis REST

## Project Description
This project implements a simple REST API that demonstrates different response formats (JSON, XML, CSV) and provides weather information for a given location. It showcases the use of Express.js for API development, implementation of DTOs (Data Transfer Objects) and Value Objects, and follows REST API best practices.

## Features
- Endpoints for JSON, XML, and CSV formats
- A location weather endpoint that accepts latitude and longitude
- Implementation of DTOs and Value Objects under a Weather namespace
- Comprehensive error handling
- Full test coverage

## Project Structure
- `app.js`: Main application file
- `routes/formatRoute.js`: Route definitions
- `controllers/FormatController.js`: Controller logic
- `models.js`: Weather namespace with Value Objects and DTO definitions
- `tests/formatRoute.test.js`: Test suite

## Setup and Installation
1. Clone the repository
2. Install dependencies:
   ```
   npm install
   ```

## Running the Application
Start the server:
```
npm start
```
The server will run on `http://localhost:3000` by default.

## API Endpoints
1. `GET /api/v1/format/:format`: Returns data in the specified format (json, xml, or csv)
2. `GET /api/v1/location-weather`: Returns weather data for a given latitude and longitude

For detailed API documentation, see `API_Documentation.md`.

## Running Tests
Execute the test suite:
```
npm test
```

## Recent Updates
- Refactored the FormatController to handle different formats using a single endpoint
- Implemented a Weather namespace for all models
- Updated tests to reflect new structure
- Updated documentation

## Contributing
Please read `CONTRIBUTING.md` for details on our code of conduct and the process for submitting pull requests.

## Versioning
This project uses Semantic Versioning. For the versions available, see the tags on this repository.

## License
This project is licensed under the MIT License - see the `LICENSE.md` file for details.

