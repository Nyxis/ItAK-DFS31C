exports.getJson = (req, res) => {
    res.set({
        'api-version': '1.0'
    });
    res.json({ hello: 'world' });
};