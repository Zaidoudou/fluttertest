const express = require('express');
const crypto = require('crypto');
const app = express();
const PORT = 8080;

app.use(express.json());

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
    const { username, password } = req.body;
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

app.get('/user', (req, res) => {
    res.status(200).send(user);
});