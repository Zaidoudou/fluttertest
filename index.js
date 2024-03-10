const express = require('express');
const crypto = require('crypto');
const app = express();
const PORT = 8080;

// here the token is stored in clear because if we encrypted it would only be displacing the problem, to properly secure it off we would need a data vault.
const authToken = 'aaTHi9gvqjEZQ72rocA4kX9TJJwkzgQkX5SL3aWxot2yoAKAZJ';

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
    PORT,
    () => console.log(`Server is running on http://localhost:${PORT}`)
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