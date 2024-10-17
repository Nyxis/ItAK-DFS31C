const API_URL = 'http://localhost:3001/api/v1';
const API_KEY = import.meta.env.VITE_API_KEY;
const API_SECRET = import.meta.env.VITE_API_SECRET;

export async function getAuthToken() {
    try {
        const response = await fetch(`${API_URL}/auth/login`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify({
                apiKey: API_KEY,
                apiSecret: API_SECRET,
            }),
        });

        if (!response.ok) {
            throw new Error(`Ошибка HTTP! статус: ${response.status}`);
        }

        const data = await response.json();
        return data.token;
    } catch (error) {
        console.error('Ошибка при получении токена аутентификации:', error);
        throw error;
    }
}
