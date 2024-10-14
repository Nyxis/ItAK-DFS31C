const express = require('express');
const router = express.Router();

router.get('/', (req, res) => {
    res.send("Bienvenue dans la version 2 de l'API");
});

router.get('/json', (req, res) => {
    res.json({ message: 'Hello World V2' });
});

router.get('/csv', (req, res) => {
    res.set('Content-Type', 'text/csv');
    res.send('message\nHello World V2');
});

router.get('/xml', (req, res) => {
    res.set('Content-Type', 'application/xml');
    res.send('<?xml version="1.0" encoding="UTF-8"?>\n<message>Hello World V2</message>');
});

module.exports = router;