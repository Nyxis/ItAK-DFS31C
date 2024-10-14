class WeatherData {
    constructor(temperature, humidite, vitesseVent) {
        if (temperature === undefined || humidite === undefined || vitesseVent === undefined) {
            throw new Error('Temperature, humidité et vitesse du Vent sont obligatoires pour WeatherData.');
        }
        this.temperature = temperature;
        this.humidite = humidite;
        this.vitesseVent = vitesseVent;
    }
}

module.exports = WeatherData;