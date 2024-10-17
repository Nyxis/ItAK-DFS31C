const FormatFactory = require('../utils/formatFactory');
const HttpStatusHandler = require('../utils/httpStatusHandler');

class HelloWorldController {
  static async getHelloWorld(req, res) {
    try {
      const acceptHeader = req.get('Accept') || '*/*';
      console.log('Received Accept header:', acceptHeader);
      const data = { hello: 'world' };
      
      const formatHandler = FormatFactory.getFormatHandler(acceptHeader);

      if (formatHandler) {
        console.log('Using format handler for:', formatHandler.mimeType);
        HttpStatusHandler.sendOk(res, formatHandler.mimeType, formatHandler.handler(data));
      } else {
        console.log('No suitable format handler found');
        HttpStatusHandler.sendNotAcceptable(res);
      }
    } catch (error) {
      console.error('Error in HelloWorldController:', error);
      HttpStatusHandler.sendInternalServerError(res);
    }
  }
}

module.exports = HelloWorldController;