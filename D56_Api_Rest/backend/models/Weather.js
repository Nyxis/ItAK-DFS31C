class Weather {
  constructor(temperature, humidity, windSpeed) {
      this._temperature = temperature;
      this._humidity = humidity;
      this._windSpeed = windSpeed;
  }

  get temperature() { return this._temperature; }
  get humidity() { return this._humidity; }
  get windSpeed() { return this._windSpeed; }

  equals(other) {
      return other instanceof Weather &&
          this._temperature === other._temperature &&
          this._humidity === other._humidity &&
          this._windSpeed === other._windSpeed;
  }

  toString() {
      return `Temperature: ${this._temperature}°C, Humidity: ${this._humidity}%, Wind Speed: ${this._windSpeed} m/s`;
  }
}

module.exports = Weather;