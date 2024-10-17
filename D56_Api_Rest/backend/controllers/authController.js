const jwt = require('jsonwebtoken');
const config = require('../config');

class AuthController {
  static async login(req, res) {
    const { apiKey, secretKey } = req.body;

    console.log('Tentative d\'authentification avec apiKey:', apiKey);

    if (!apiKey || !secretKey) {
      console.log('Échec: apiKey ou secretKey manquant');
      return res.status(400).json({ error: 'Les champs apiKey et secretKey sont requis' });
    }

    if (apiKey !== config.API_KEY || secretKey !== config.API_SECRET) {
      console.log('Échec: apiKey ou secretKey invalide');
      return res.status(401).json({ error: 'Clé API ou clé secrète invalide' });
    }

    const token = jwt.sign({ apiKey }, config.JWT_SECRET, { expiresIn: '1h' });

    console.log('Authentification réussie, token généré');
    res.json({ token });
  }
}

module.exports = AuthController;