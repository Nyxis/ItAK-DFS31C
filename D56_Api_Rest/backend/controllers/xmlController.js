const xml2js = require('xml2js');

class XmlController {
  handleXmlRequest(data) {
    const builder = new xml2js.Builder();
    return builder.buildObject(data);
  }
}

module.exports = XmlController;