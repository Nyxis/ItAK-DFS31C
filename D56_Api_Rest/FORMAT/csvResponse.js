class CsvResponse {
    format(data) {
        const keys = Object.keys(data).map(key => `${key}\\n`); 
        const values = Object.values(data).map(value => `${value}\\n`); 
        
        return `${keys.join('\n')}\n${values.join('\n')}\n`;
    }
}

module.exports = CsvResponse;
