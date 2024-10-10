const express = require('express');
const app = express();
const port = 3001;

const V2Router = require('./router/V2');

app.use('/api/v2', V2Router);

app.get('/', (req, res) => {
    res.send("Bienvenue dans mon serveur");
});

app.get('/api/json', (req, res) => {
    res.json({ message: 'Hello World' });
});

app.get('/api/csv', (req, res) => {
    res.set('Content-Type', 'text/csv');
    res.send('message\nHello World');
});

app.get('/api/xml', (req, res) => {
    res.set('Content-Type', 'application/xml');
    res.send('<?xml version="1.0" encoding="UTF-8"?>\n<message>Hello World</message>');
});

app.use((req, res) => {
    res.status(404).send('Vous avez fait une erreur dans vos requêtes');
});

app.listen(port, () => {
    console.log(`Serveur Express en écoute sur http://localhost:${port}`);
});