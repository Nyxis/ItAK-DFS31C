import dotenv from 'dotenv';
import { fileURLToPath } from 'url';
import { dirname, join } from 'path';
import express from 'express';
import formatRoute from './routes/formatRoute.js';
import hypermediaRoute from './routes/hypermediaRoute.js'; // Import the new route

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

dotenv.config({ path: join(__dirname, '.env') });

const app = express();
const port = process.env.PORT || 3000;

app.use('/api/v1', formatRoute(process.env.OPENWEATHERMAP_API_KEY));

// Add the new homepage route at the root of the API
app.use('/api', hypermediaRoute);

app.listen(port, () => {
    console.log(`Server running at http://localhost:${port}`);
});

export { app };

