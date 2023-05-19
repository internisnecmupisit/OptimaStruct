const { default: axios } = require('axios');
const express = require('express');
const dotenv = require('dotenv');
dotenv.config();

const app = express();

// app.use(express.static('public'));

const PORT = process.env.PORT || 80;
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});