class Coordonnees {
    constructor(latitude, longitude) {
      this.latitude = latitude;
      this.longitude = longitude;
    }
  }
  
  class Ville {
    constructor(nom) {
      this.nom = nom;
    }
  }
  
  class Pays {
    constructor(nom) {
      this.nom = nom;
    }
  }
  
  class Lieu {
    constructor(nom, coordonnees, ville, pays) {
      this.nom = nom;
      this.coordonnees = coordonnees;
      this.ville = ville;
      this.pays = pays;
    }
  }
  
  module.exports = { Lieu, Coordonnees, Ville, Pays };