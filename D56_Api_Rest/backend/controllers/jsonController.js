class JsonController {
  handleJsonRequest(data) {
    return JSON.stringify(data);
  }
}

module.exports = JsonController;