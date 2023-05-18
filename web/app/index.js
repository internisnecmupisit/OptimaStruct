const { default: axios } = require('axios');
const express = require('express');
const dotenv = require('dotenv');
const ejs = require('ejs');
dotenv.config();

const app = express();

// Set EJS as the view engine
app.set('view engine', 'ejs');

// app.use(express.static('public'));

const PORT = process.env.PORT || 80;
app.listen(PORT, () => {
    console.log(`Server listening on port ${PORT}`);
});

app.get('/', (req, res) => {
    const apiUrl = `${process.env.API_URL}`;
    res.render('index', { apiUrl });
    // res.sendFile(__dirname + '/public/index.html');
});