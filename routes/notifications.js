const express = require('express');
const axios = require('axios');
const router = express.Router();

router.use(express.json());

router.post('/sendnotif', (req, res) => {
  let data = JSON.stringify(req.body);

  let config = {
    method: 'post',
    maxBodyLength: Infinity,
    url: 'https://fcm.googleapis.com/fcm/send',
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'key=AAAAEphUpIA:APA91bGGvqC7XAeNnSsKSj1KOL8IwQNfMbAobPqHwfq17_tzH1S-jtKyrpn1NF2jpXc80kC2q-gZkTrfhc-zypbhtREiZwObMKZNRZ43ZzErtACgzDgBdt254Rtt7VKE90bq50hugmR5'
    },
    data: data
  };

  axios.request(config)
    .then((response) => {
      res.json(response.data);
    })
    .catch((error) => {
      res.status(500).json({ error: error.message }); 
    });
});

module.exports = router;
