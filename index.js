const express = require('express');
const crypto = require('crypto');
const fs = require('fs');
const app = express();

const config = JSON.parse(fs.readFileSync('data.json', 'utf8'));
const authToken = config.authToken;
const serverHost = config.serverHost;
const serverPort = config.serverPort;


const authMiddleware = (req, res, next) => {
    const token = req.headers.authorization;
    if (token === authToken) {
        next();
    } else {
        res.status(401).send('Unauthorized');
    }
};

app.use(express.json());
app.use(authMiddleware);

app.listen(
    serverPort,
    () => console.log(`Server is running on http://${serverHost}:${serverPort}`)
);

app.post('/login', (req, res) => {
    const { username, password } = req.body;
    const cipher = crypto.createCipher('aes192', 'awWjqAZnd6g3XgtFouFXUj9g5d2xdSp');
    let encrypted = cipher.update(password, 'utf8', 'hex');
    encrypted += cipher.final('hex');
    if (username === user.username && encrypted === user.password) {
        res.status(200).send('Login successful');
    } else {
        res.status(401).send('Invalid credentials');
    }
});

app.post('/register', (req, res) => {
    const { username, password, } = req.body;
    if (username && password) {
        const cipher = crypto.createCipher('aes192', 'awWjqAZnd6g3XgtFouFXUj9g5d2xdSp');
        let encrypted = cipher.update(password, 'utf8', 'hex');
        encrypted += cipher.final('hex');
        user = {
            username,
            password: encrypted
        };
        res.status(200).send('Registration successful');
    } else {
        res.status(400).send('Invalid input');
    }
});

app.delete('/user', (req, res) => {
        user = {};
        res.status(200).send('User deleted');
});

app.get('/user', (req, res) => {
    res.status(200).send(user);
});