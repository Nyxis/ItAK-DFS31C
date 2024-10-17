const crypto = require('crypto');

// Генерация JWT_SECRET
const jwtSecret = crypto.randomBytes(64).toString('hex');
console.log('JWT_SECRET:', jwtSecret);

// Генерация API_KEY
const apiKey = crypto.randomBytes(32).toString('hex');
console.log('API_KEY:', apiKey);

// Генерация API_SECRET
const apiSecret = crypto.randomBytes(64).toString('hex');
console.log('API_SECRET:', apiSecret);