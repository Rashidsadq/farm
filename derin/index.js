const express = require('express');
const path = require('path');
const app = express();

app.use(express.json());
app.use(express.urlencoded({ extended: true }));

const PORT = 3000;

// Serve HTML and static files from current directory
app.use(express.static(path.join(__dirname)));

// Fake user
const fakeUser = {
  username: 'admin',
  password: '1234'
};

// Handle login request
app.post('/login', (req, res) => {
  const { username, password } = req.body;

  if (username === fakeUser.username && password === fakeUser.password) {
    res.status(200).send({ message: 'Login successful!' });
  } else {
    res.status(401).send({ message: 'Invalid credentials' });
  }
});

app.listen(PORT, () => {
  console.log(`✅ Server is running at http://localhost:${PORT}`);
});


const oracledb = require('oracledb');
const bodyParser = require('body-parser');

const port = 3000;

app.use(bodyParser.json());
app.use(express.static(path.join(__dirname))); // serves signup.html

const dbConfig = {
  user: 'your_username',           // <-- your Oracle username
  password: 'your_password',       // <-- your Oracle password
  connectString: 'localhost/XEPDB1' // <-- your Oracle connection string
};

app.post('/signup', async (req, res) => {
  const { username, password } = req.body;

  try {
    const connection = await oracledb.getConnection(dbConfig);

    // check if user exists
    const check = await connection.execute(
      'SELECT * FROM users1 WHERE username = :username',
      [username]
    );

    if (check.rows.length > 0) {
      await connection.close();
      return res.status(409).send({ message: 'Username already exists' });
    }

    // insert new user
    await connection.execute(
      'INSERT INTO users1 (username, password) VALUES (:username, :password)',
      [username, password],
      { autoCommit: true }
    );

    await connection.close();
    res.status(201).send({ message: 'User registered successfully!' });

  } catch (err) {
    console.error(err);
    res.status(500).send({ message: 'Signup failed. Server error.' });
  }
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
