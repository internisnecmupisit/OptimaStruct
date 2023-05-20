const express = require("express");
const cors = require("cors");
const path = require('path');
const fs = require('fs');
require("dotenv").config();

const app = express();
app.use(express.json());
app.use(cors());

const { LOG_PASSWORD } = process.env;
const logFilePath = path.join(__dirname, 'log.txt');

app.get('/', (req, res) => {
    res.sendFile(__dirname + '/public/index.html');
});

// Define a middleware function to validate the password parameter
function validatePassword(req, res, next) {
    const { password } = req.query;
    if (password === LOG_PASSWORD) {
        next();
    } else {
        res.status(401).send('Invalid password');
    }
}

app.post("/checkPalindrome", async (req, res) => {
    const input = req.body.input.toLowerCase().replace(/[^a-zA-Z0-9]/g, "");
    const reversed = input.split("").reverse().join("");
    const isPalindrome = input === reversed;
    if (isPalindrome) {
        res.status(200).json({ message: `${input} is a palindrome!` });
        writeLog(`${input} is a palindrome.`);
    } else {
        res.status(200).json({ message: `${input} is not a palindrome.` });
        writeLog(`${input} is not a palindrome.`);
    }

});

app.get('/logs', validatePassword, (req, res) => {
    res.sendFile(logFilePath);
});

const writeLog = (msg) => {
    fs.appendFile(logFilePath, msg + '\n', (err) => {
        if (err) console.error(err);
    });
}

const PORT = process.env.PORT || 5000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));
