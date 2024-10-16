const jwt = require('jsonwebtoken');
const apiKey = process.env.API_KEY; // Store your API key in .env
const secretKey = process.env.SECRET_KEY; // Store your secret key in .env

class JWTService {
    static generateToken(payload) {
        return jwt.sign(payload, secretKey + apiKey, { expiresIn: '1h' });
    }

    static verifyToken(token) {
        try {
            return jwt.verify(token, secretKey + apiKey);
        } catch (err) {
            throw new Error('Invalid token');
        }
    }
}

module.exports = JWTService;