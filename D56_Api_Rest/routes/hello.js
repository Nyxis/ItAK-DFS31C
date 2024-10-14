const express = require('express');
const jsonFormatter = require('../formatters/jsonFormatter');
const xmlFormatter = require('../formatters/xmlFormatter');
const csvFormatter = require('../formatters/csvFormatter');

const router = express.Router();

/**
 * @api {get} /hello Renvoie un Hello
 * @apiVersion 1.0.0
 * @apiName GetHello
 * @apiGroup Hello
 *
 * @apiHeader {String} Accept Format de réponse souhaité (application/json, application/xml, text/csv)
 *
 * @apiSuccess {String} hello Message Hello.
 *
 * @apiSuccessExample {json} Réponse en JSON:
 *     HTTP/1.1 200 OK
 *     {
 *       "hello": "world"
 *     }
 *
 * @apiSuccessExample {xml} Réponse en XML:
 *     HTTP/1.1 200 OK
 *     <hello>world</hello>
 *
 * @apiSuccessExample {csv} Réponse en CSV:
 *     HTTP/1.1 200 OK
 *     hello,world
 */
router.get('/hello', (req, res) => {
    const data = { hello: 'world' };
    const acceptHeader = req.headers.accept || '';

    const formatters = {
        'application/json': {
            formatter: jsonFormatter,
            contentType: 'application/json'
        },
        'application/xml': {
            formatter: xmlFormatter,
            contentType: 'application/xml'
        },
        'text/csv': {
            formatter: csvFormatter,
            contentType: 'text/csv'
        }
    };

    const supportedFormats = Object.keys(formatters);

    // Trouver format en fonction de l'en-tête Accept
    const format = supportedFormats.find((format) => acceptHeader.includes(format));

    if (!format) {
        res.status(406).send('Format non supporté');
        return;
    }

    const { formatter, contentType } = formatters[format];

    res.set('Content-Type', contentType);
    res.send(formatter.format(data));
});

module.exports = router;
