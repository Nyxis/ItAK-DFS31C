const express = require('express');
const router = express.Router();
const jsonController = require('../controllers/jsonController');

router.get('/json', jsonController.getJson);

module.exports = router;