exports.getCsv = (req, res) => {
    res.status(200).set({
        'Content-Type': 'text/csv',
        'api-version': '1.0'
    });
    res.send('hello\nworld');
};