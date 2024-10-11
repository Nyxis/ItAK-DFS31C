class CsvResponse {
    format(data) {
        return `country,latitude,longitude,temperature,weatherDescription,windSpeed,humidity\n${data.country},${data.latitude},${data.longitude},${data.temperature},${data.weatherDescription},${data.windSpeed},${data.humidity}\n`;
    }
}

module.exports = CsvResponse;
