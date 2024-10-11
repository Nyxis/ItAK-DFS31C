const express = require('express');
const app = express();
const port = 3000;

// Import our route
const formatRoute = require('./routes/formatRoute');

// Use the route
app.use('/api/v1', formatRoute);

let server;
if (process.env.NODE_ENV !== 'test') {
    server = app.listen(port, () => {
        console.log(`Server running at http://localhost:${port}`);
    });
}

// Function to close the server
const closeServer = () => {
    return new Promise((resolve) => {
        if (server) {
            server.close(() => {
                resolve();
            });
        } else {
            resolve();
        }
    });
};

module.exports = { app, closeServer };  // Export both app and closeServer function
