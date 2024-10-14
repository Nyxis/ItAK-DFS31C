const jwt = require('jsonwebtoken');
require('dotenv').config();

const secretKey = process.env.SECRET_KEY;
const apiKey = process.env.API_KEY;

const payload = { name: 'Paris' };
const signature = jwt.sign(payload, secretKey + apiKey);
console.log(signature);


// Petit stcript pour générer une signature pour JWT