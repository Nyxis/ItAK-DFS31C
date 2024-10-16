exports.getJson = (req, res) => {
    res.set({
        'Content-Type': 'application/json; charset=utf-8',
        'api-version': '1.0'
    });
    res.json({ hello: 'world' });
};