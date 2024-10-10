DOCUMENTATION
---

# API Exercice Documentation

## Overview

This project consists of a basic Node.js API that serves responses in different formats (JSON, XML, CSV) based on the routes. The API is versioned to ensure future scalability, and the current version is `V1`.

## API Routes

### `/APIexercice/V1/json`

- **Description**: Returns a JSON object `{ "hello": "world" }`
- **Response**:
  ```json
  {
    "hello": "world"
  }
  ```

### `/APIexercice/V1/xml`

- **Description**: Returns an XML string `<hello>world</hello>`
- **Response**:
  ```xml
  <hello>world</hello>
  ```

### `/APIexercice/V1/csv`

- **Description**: Returns a CSV string `hello\nworld`
- **Response**:
  ```
  hello
  world
  ```

## Folder Structure

### Controllers

- **jsonController.js**: Handles the logic for the `/json` route.
- **xmlController.js**: Handles the logic for the `/xml` route.
- **csvController.js**: Handles the logic for the `/csv` route.

### Routes

- **json.js**: Maps the `/json` route to `jsonController`.
- **xml.js**: Maps the `/xml` route to `xmlController`.
- **csv.js**: Maps the `/csv` route to `csvController`.

### Index.js

- Sets up the server and imports routes with versioning.
- Defines the root route (`/`) that displays buttons for each format.

## How to Run

1. **Install dependencies**:
    ```
    npm install
    ```

2. **Start the server**:
    ```
    node index.js
    ```

3. **Test the routes**:
    Navigate to `http://localhost:3000` to see the homepage with buttons for each format, or directly visit:
    - JSON: `http://localhost:3000/APIexercice/V1/json`
    - XML: `http://localhost:3000/APIexercice/V1/xml`
    - CSV: `http://localhost:3000/APIexercice/V1/csv`

## How to Add New Versions

To add a new version (e.g., `V2`):
1. Create new route and controller files for `V2`.
2. Update `index.js` to include the new version prefix (`/APIexercice/V2`).
3. Ensure all new routes have the correct version in their URLs.

## Future Enhancements

- Add support for more data formats.
- Implement query parameters to dynamically change the response content.
- Expand versioning logic to handle deprecated routes.

---
