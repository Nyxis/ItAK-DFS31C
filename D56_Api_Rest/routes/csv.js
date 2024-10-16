const express = require('express');
const router = express.Router();
const csvController = require('../controllers/csvController');

router.get('/csv', csvController.getCsv);

module.exports = router;