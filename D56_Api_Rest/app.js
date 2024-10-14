import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import express from 'express';
import formatRoute from './routes/formatRoute.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config({ path: join(__dirname, '.env') });

console.log('OPENWEATHERMAP_API_KEY:', process.env.OPENWEATHERMAP_API_KEY);

const app = express();
const port = process.env.PORT || 3000;

app.use('/api/v1', formatRoute(process.env.OPENWEATHERMAP_API_KEY));

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});

export { app };

