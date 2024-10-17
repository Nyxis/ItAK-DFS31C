class HttpStatusHandler {
    static sendOk(res, contentType, data) {
      res.status(200).type(contentType).send(data);
    }
  
    static sendBadRequest(res, message = 'Bad Request') {
      res.status(400).json({ error: message });
    }
  
    static sendNotFound(res, message = 'Not Found') {
      res.status(404).json({ error: message });
    }
  
    static sendMethodNotAllowed(res, message = 'Method Not Allowed') {
      res.status(405).json({ error: message });
    }
  
    static sendNotAcceptable(res, message = 'Not Acceptable') {
      res.status(406).json({ error: message });
    }
  
    static sendInternalServerError(res, message = 'Internal Server Error') {
      res.status(500).json({ error: message });
    }
  }
  
  module.exports = HttpStatusHandler;