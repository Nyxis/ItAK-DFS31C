const City = require('../value_objects/city');

class Location {
    constructor(name, latitude, longitude, city) {
        if (!name || !latitude || !longitude || !city) {
            throw new Error('All fields are required for Location.');
        }
        this.name = name;
        this.latitude = latitude;
        this.longitude = longitude;
        this.city = city;
    }
}

module.exports = Location;