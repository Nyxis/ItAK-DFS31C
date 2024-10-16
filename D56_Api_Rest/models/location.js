class Location {
    constructor(name, country, region, lat, lon, timezoneId, localtime, utcOffset) {
        this.name = name;               // Name of the location (e.g., "New York")
        this.country = country;         // Country (e.g., "United States of America")
        this.region = region;           // Region (e.g., "New York")
        this.lat = lat;                 // Latitude (e.g., "40.714")
        this.lon = lon;                 // Longitude (e.g., "-74.006")
        this.timezoneId = timezoneId;   // Timezone ID (e.g., "America/New_York")
        this.localtime = localtime;     // Local time (e.g., "2019-09-07 08:14")
        this.utcOffset = utcOffset;     // UTC Offset (e.g., "-4.0")
    }
}

module.exports = Location;