import React, { useState, useEffect, useCallback } from "react";

const API_URL = 'http://localhost:3001/api/v1';
const API_KEY = import.meta.env.VITE_API_KEY;
const API_SECRET = import.meta.env.VITE_API_SECRET;

const HelloWorld = () => {
  const [result, setResult] = useState('');
  const [token, setToken] = useState('');

  const authenticate = useCallback(async () => {
    try {
      const response = await fetch(`${API_URL}/auth`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ apiKey: API_KEY, secretKey: API_SECRET }),
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.json();
      setToken(data.token);
      console.log('Token received:', data.token);
      return data.token;
    } catch (error) {
      console.error('Authentication error:', error);
      setResult(`Authentication error: ${error.message}`);
    }
  }, []);

  useEffect(() => {
    authenticate();
  }, [authenticate]);

  const fetchData = async (format) => {
    try {
      let currentToken = token;
      if (!currentToken) {
        currentToken = await authenticate();
      }

      if (!currentToken) {
        throw new Error('Failed to obtain authentication token');
      }

      const response = await fetch(`${API_URL}/hello`, {
        method: 'GET',
        headers: {
          'Accept': format,
          'Authorization': `Bearer ${currentToken}`,
        },
      });

      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }

      const data = await response.text();
      setResult(data);
    } catch (error) {
      console.error('Error fetching data:', error);
      setResult(`Error fetching data: ${error.message}`);
    }
  };

  return (
    <div>
      <h2>Test de l'API Hello World</h2>
      <div>
        <button onClick={() => fetchData('application/json')}>JSON</button>
        <button onClick={() => fetchData('application/xml')}>XML</button>
        <button onClick={() => fetchData('text/csv')}>CSV</button>
      </div>
      <p>{result || 'Cliquez sur un bouton pour obtenir les données'}</p>
    </div>
  );
};

export default HelloWorld;