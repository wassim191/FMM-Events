const express = require('express');
const app = express();
const axios = require('axios');
const cors = require('cors');
const bodyParser = require('body-parser');
const mongoose = require('mongoose');

mongoose.connect('mongodb://127.0.0.1:27017/db', { useNewUrlParser: true,
useUnifiedTopology: true,  })
  .then(() => console.log('Connected successfully to MongoDB'))
  .catch((error) => console.error('Error connecting to MongoDB:', error));
  

app.use(cors());
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use('/', require('./routes/user.route'));
app.use('/', require('./routes/Admins.route'));
app.use('/', require('./routes/courses.route'));
app.use('/', require('./routes/pay'));
app.use('/', require('./routes/Equipements.route'));

app.use('/', require('./routes/notifications'));



app.listen(3002, () => console.log('Server is listening on port 3002'));
