const JsonController = require('../controllers/jsonController');
const XmlController = require('../controllers/xmlController');
const CsvController = require('../controllers/csvController');

class FormatFactory {
  static getFormatHandler(acceptHeader) {
    console.log('Searching handler for:', acceptHeader);
    const formatHandlers = {
      'application/json': new JsonController().handleJsonRequest,
      'application/xml': new XmlController().handleXmlRequest,
      'text/csv': new CsvController().handleCsvRequest
    };

    for (const [mimeType, handler] of Object.entries(formatHandlers)) {
      if (acceptHeader.includes(mimeType)) {
        console.log('Handler found for:', mimeType);
        return { mimeType, handler };
      }
    }

    console.log('No specific handler found, defaulting to JSON');
    return { mimeType: 'application/json', handler: formatHandlers['application/json'] };
  }
}

module.exports = FormatFactory;