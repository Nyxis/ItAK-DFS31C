module.exports = {
    format: (data) => {
        const keys = Object.keys(data);
        const values = keys.map(key => data[key]);
        return `${keys.join(',')}\n${values.join(',')}`;
    }
};
