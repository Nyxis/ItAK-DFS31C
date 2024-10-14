class DonneeLieuMeteo {
    constructor(lieu, donneeMeteo) {
      this.nom = lieu.nom;
      this.latitude = lieu.coordonnees.latitude;
      this.longitude = lieu.coordonnees.longitude;
      this.ville = lieu.ville.nom;
      this.pays = lieu.pays.nom;
      this.temperature = donneeMeteo.temperature;
      this.humidite = donneeMeteo.humidite;
      this.vitesseVent = donneeMeteo.vitesseVent;
    }
  }
  
  module.exports = DonneeLieuMeteo;