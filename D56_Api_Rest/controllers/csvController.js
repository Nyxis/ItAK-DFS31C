exports.getCsv = (req, res) => {
    res.status(200).set({
        'Content-Type': 'text/csv; charset=utf-8',
        'api-version': '1.0'
    });
    res.send('hello\nworld');
};