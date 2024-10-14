require('dotenv').config();
const jwt = require('jsonwebtoken');

const secretKey = process.env.SECRET_KEY;

module.exports = (req, res, next) => {
    const authHeader = req.headers['authorization'];

    if (!authHeader) {
        return res.status(401).send('Token d\'autorisation manquant.');
    }

    const token = authHeader.split(' ')[1];
    if (!token) {
        return res.status(401).send('Token d\'autorisation invalide.');
    }

    try {
        // Vérif token
        jwt.verify(token, secretKey);
    } catch (error) {
        return res.status(401).send('Token invalide.');
    }
    next();
};
