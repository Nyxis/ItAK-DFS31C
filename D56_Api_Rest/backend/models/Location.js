class Location {
  constructor(name, latitude, longitude, city, country) {
      this._name = name;
      this._latitude = latitude;
      this._longitude = longitude;
      this._city = city;
      this._country = country;
  }

  get name() { return this._name; }
  get latitude() { return this._latitude; }
  get longitude() { return this._longitude; }
  get city() { return this._city; }
  get country() { return this._country; }

  equals(other) {
      return other instanceof Location &&
          this._name === other._name &&
          this._latitude === other._latitude &&
          this._longitude === other._longitude &&
          this._city === other._city &&
          this._country === other._country;
  }

  toString() {
      return `${this._name}, ${this._city}, ${this._country}`;
  }
}

module.exports = Location;