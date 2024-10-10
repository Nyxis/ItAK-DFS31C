class XmlResponse {
    format(data) {
        const key = Object.keys(data)[0];
        const value = data[key];
        return `<${key}>${value}</${key}>`;
    }
}

module.exports = XmlResponse;
