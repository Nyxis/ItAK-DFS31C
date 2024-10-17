const { stringify } = require('csv-stringify/sync');

class CsvController {
  handleCsvRequest(data) {
    return stringify([Object.keys(data), Object.values(data)]);
  }
}

module.exports = CsvController;