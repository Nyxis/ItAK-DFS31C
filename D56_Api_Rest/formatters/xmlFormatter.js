module.exports = {
    format: (data) => {
        const keys = Object.keys(data);
        const xmlElements = keys.map(key => `<${key}>${data[key]}</${key}>`);
        return `<response>${xmlElements.join('')}</response>`;
    }
};