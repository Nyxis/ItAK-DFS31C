require('dotenv').config();
const axios = require('axios');
const readline = require('readline');

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

rl.question('Entrez le lieu : ', async (lieu) => {
    try {
        const apiKey = process.env.API_KEY;
        const secretKey = process.env.SECRET_KEY;
        const version = 'v1';

        // Appel homepage
        const homepageResponse = await axios.get('http://localhost:3000/api/v1/homepage', {
            params: { apiKey, secretKey, version }
        });

        const { token, links } = homepageResponse.data;

        if (!links || !links.weatherData) {
            throw new Error("Le lien 'weatherData' est manquant dans la réponse de la homepage.");
        }

        const weatherDataUrl = `http://localhost:3000${links.weatherData.href}`;

        // lien vers les datas météo
        const weatherResponse = await axios.get(weatherDataUrl, {
            headers: { 
                'Authorization': `Bearer ${token}`,
                'x-api-key': apiKey
            },
            params: { name: lieu }
        });

        // Résultat passé par le dto locationWeatherData
        console.log('Données météo :', JSON.stringify(weatherResponse.data, null, 2));

    } catch (error) {
        if (error.response) {
            console.error('Erreur de la réponse :', error.response.status, error.response.data);
        } else if (error.request) {
            console.error('Erreur de requête, aucune réponse reçue :', error.request);
        } else {
            console.error('Erreur lors de la requête :', error.message);
        }
    } finally {
        rl.close();
    }
});
