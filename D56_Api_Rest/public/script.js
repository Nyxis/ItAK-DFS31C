// Function to fetch the API key (via the auth endpoint)
function generateToken() {
    fetch('/APIexercice/V1/auth', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' }
    })
    .then(response => response.json())
    .then(data => {
        if (data.token) {
            document.getElementById('tokenDisplay').textContent = data.token;
            document.getElementById('apiKey').value = data.token; // Save token for further requests
        } else {
            alert('Error generating token: ' + (data.error || 'Unknown error'));
        }
    })
    .catch(error => console.error('Error generating token:', error));
}

// Attach token generation to the button
document.getElementById('generateTokenBtn').addEventListener('click', generateToken);

// Function to query weather data by city
function getWeatherByCity() {
    const city = document.getElementById('city').value;
    const token = document.getElementById('apiKey').value;

    if (!city || !token) {
        alert('Please provide a city name and your API token.');
        return;
    }

    fetch(`/APIexercice/V1/locationWeatherData?city=${city}`, {
        headers: {
            'Authorization': 'Bearer ' + token // Format Authorization header
        }
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById('result').textContent = JSON.stringify(data, null, 2);
    })
    .catch(error => {
        document.getElementById('result').textContent = 'Error: ' + error.message;
    });
}

// Function to query weather data by GPS coordinates
function getWeatherByCoordinates() {
    const lat = document.getElementById('lat').value;
    const lon = document.getElementById('lon').value;
    const token = document.getElementById('apiKey').value;

    if (!lat || !lon || !token) {
        alert('Please provide latitude, longitude, and your API token.');
        return;
    }

    fetch(`/APIexercice/V1/locationWeatherData?lat=${lat}&lon=${lon}`, {
        headers: {
            'Authorization': 'Bearer ' + token // Format Authorization header
        }
    })
    .then(response => response.json())
    .then(data => {
        document.getElementById('result').textContent = JSON.stringify(data, null, 2);
    })
    .catch(error => {
        document.getElementById('result').textContent = 'Error: ' + error.message;
    });
}