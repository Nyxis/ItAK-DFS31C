const express = require('express');
const router = express.Router();
const xmlController = require('../controllers/xmlController');

router.get('/xml', xmlController.getXml);

module.exports = router;