const js2xmlparser = require('js2xmlparser');

class XmlResponse {
    format(data) {
        return js2xmlparser.parse('LocationWeatherData', data);
    }
}

module.exports = XmlResponse;
