class City {
    constructor(name, country) {
        if (!name || !country) {
            throw new Error('Name and Country are required for City.');
        }
        this.name = name;
        this.country = country;
    }

    toString() {
        return `${this.name}, ${this.country}`;
    }
}

module.exports = City;