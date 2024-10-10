exports.getXml = (req, res) => {
    res.status(200).set({
        'Content-Type': 'application/xml',
        'api-version': '1.0'
    });
    res.send('<hello>world</hello>');
};