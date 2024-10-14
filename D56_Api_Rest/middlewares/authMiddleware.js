require('dotenv').config();
const jwt = require('jsonwebtoken');

const apiKey = process.env.API_KEY;
const secretKey = process.env.SECRET_KEY;

module.exports = (req, res, next) => {
    // Vérif clé API
    const apiKeyHeader = req.headers['x-api-key'];
    if (!apiKeyHeader || apiKeyHeader !== apiKey) {
        return res.status(401).send('Clé API invalide ou manquante.');
    }

    // Vérif signature JWT
    const signatureHeader = req.headers['x-signature'];
    if (!signatureHeader) {
        return res.status(401).send('Signature JWT manquante.');
    }

    try {
        jwt.verify(signatureHeader, secretKey + apiKey);
    } catch (error) {
        return res.status(401).send('Signature invalide.');
    }
    next();
};
