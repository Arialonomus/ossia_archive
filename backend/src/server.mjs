import express from 'express';
import cors from 'cors';
import config from '../config/server-config.json' assert { type: 'json' };

// Configure middleware
const app = express();
const port = config.backEndPort;
const frontEndURL =  `${config.frontEndUrlRoot}${config.frontEndPort}`

// Allow URL through CORS
app.use(cors({
  origin: frontEndURL
}));

// Test endpoint
app.get('/', (req, res) => {
  res.json({ message: 'Ossia Archive Backend API' });
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});