const express = require('express');
const app = express();
const path = require('path');
const port = 3000;
const version = 'V1';

app.use(express.static('public'));

app.use('/documentation', (req, res) =>{
    res.sendFile(path.join(__dirname, 'DOC', 'find' , 'documentation.md'));
});

app.get('/', (req, res) => {
    res.send(`
        <html>
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>API Exercice</title>
            <link rel="stylesheet" href="styles.css">
        </head>
            <body>
                <h1>Bienvenue!</h1>
                <p>Voici les différentes routes disponibles : </p>
                <ul>
                    <li><button onclick="window.location.href='/APIexercice/${version}/json'">Go to JSON Route</button></li>
                    <li><button onclick="window.location.href='/APIexercice/${version}/xml'">Go to XML Route</button></li>
                    <li><button onclick="window.location.href='/APIexercice/${version}/csv'">Go to CSV Route</button></li>
                </ul>
            </body>
            <footer>
                <p><a href="/documentation">Documentation</a></p>
            </footer>
        </html>
    `);
});

const jsonRoutes = require('./routes/json');
const xmlRoutes = require('./routes/xml');
const csvRoutes = require('./routes/csv');

app.use(`/APIexercice/${version}`, jsonRoutes);
app.use(`/APIexercice/${version}`, xmlRoutes);
app.use(`/APIexercice/${version}`, csvRoutes);

app.listen(port, () => {
    console.log(`Exercice app listening on port ${port}`);
});