import React, { useState, useEffect } from 'react';

const API_URL = 'http://localhost:3001/api/v1';
const API_KEY = import.meta.env.VITE_API_KEY;
const API_SECRET = import.meta.env.VITE_API_SECRET;

const LocationWeather = () => {
  const [result, setResult] = useState(null);
  const [location, setLocation] = useState('');
  const [loading, setLoading] = useState(false);
  const [token, setToken] = useState('');

  useEffect(() => {
    authenticate();
  }, []);

  const authenticate = async () => {
    try {
      const response = await fetch(`${API_URL}/auth`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ apiKey: API_KEY, secretKey: API_SECRET }),
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Erreur HTTP ! statut : ${response.status}, message : ${errorData.error}`);
      }

      const data = await response.json();
      setToken(data.token);
      console.log('Jeton reçu :', data.token);
    } catch (error) {
      console.error('Erreur d\'authentification :', error);
      setResult(`Erreur d'authentification : ${error.message}`);
    }
  };

  const fetchWeather = async () => {
    if (!location) {
      setResult('Veuillez entrer un emplacement');
      return;
    }

    setLoading(true);
    try {
      if (!token) {
        await authenticate();
      }

      const response = await fetch(`${API_URL}/weather?location=${encodeURIComponent(location)}`, {
        headers: {
          'Accept': 'application/json',
          'Authorization': `Bearer ${token}`,
        },
      });

      if (!response.ok) {
        const errorData = await response.json();
        throw new Error(`Erreur HTTP ! statut : ${response.status}, message : ${errorData.error}`);
      }

      const data = await response.json();
      setResult(data);
    } catch (error) {
      console.error('Erreur :', error);
      setResult(`Erreur lors de la récupération des données : ${error.message}`);
    } finally {
      setLoading(false);
    }
  };

  const handleInputChange = (e) => {
    setLocation(e.target.value);
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    fetchWeather();
  };

  return (
    <div>
      <h2>Météo par emplacement</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          placeholder="Entrez l'emplacement"
          value={location}
          onChange={handleInputChange}
        />
        <button type="submit" disabled={loading}>
          {loading ? 'Chargement...' : 'Obtenir la météo'}
        </button>
      </form>
      <div>
        {result && typeof result === 'object' ? (
          <>
            <p><strong>Emplacement :</strong> {result.name}</p>
            <p><strong>Température :</strong> {result.temperature}°C</p>
            <p><strong>Humidité :</strong> {result.humidity}%</p>
            <p><strong>Vitesse du vent :</strong> {result.windSpeed} m/s</p>
          </>
        ) : (
          <p>{result || 'Entrez un emplacement et cliquez sur "Obtenir la météo" pour récupérer les données'}</p>
        )}
      </div>
    </div>
  );
};

export default LocationWeather;