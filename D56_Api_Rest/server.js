const express = require('express');
const JsonResponse = require('./FORMAT/jsonResponse');
const XmlResponse = require('./FORMAT/xmlResponse');
const CsvResponse = require('./FORMAT/csvResponse');
const app = express();
const PORT = process.env.PORT || 3000;

// Classe pour gérer les formats de réponse
class ResponseFormatter {
    constructor(formatter) {
        this.formatter = formatter;
    }

    sendResponse(data, res) {
        res.send(this.formatter.format(data));
    }
}

// Route pour la page de choix de format
app.get('/', (req, res) => {
    res.send(`
        <h1>Choisissez un format de réponse</h1>
        <a href="/api/hello" onclick="return sendRequest('application/json')">JSON</a><br>
        <a href="/api/hello" onclick="return sendRequest('application/xml')">XML</a><br>
        <a href="/api/hello" onclick="return sendRequest('text/csv')">CSV</a>
        <script>
            function sendRequest(format) {
                fetch('/api/hello', {
                    headers: {
                        'Accept': format
                    }
                }).then(response => response.text()).then(text => {
                    const pre = document.createElement('pre');
                    pre.textContent = text;
                    document.body.appendChild(pre);
                });
                return false; // Evite le rechargement de la page
            }
        </script>
    `);
});

// Endpoint pour répondre selon le format
app.get('/api/hello', (req, res) => {
    const acceptHeader = req.headers['accept']; // Lire le format depuis les headers
    const data = { hello: 'world' };
    let formatter;

    if (acceptHeader.includes('application/xml')) {
        formatter = new ResponseFormatter(new XmlResponse());
    } else if (acceptHeader.includes('text/csv')) {
        formatter = new ResponseFormatter(new CsvResponse());
    } else {
        formatter = new ResponseFormatter(new JsonResponse());
    }

    formatter.sendResponse(data, res);
});

// Lancer le serveur
app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
});
