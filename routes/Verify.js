
const axios = require("axios");
const { MongoClient } = require("mongodb");

async function Verify(req, res) {
  const id_payment = req.params.id;
  const url = `https://api.preprod.konnect.network/api/v2/payments/${id_payment}`;
  const headers = {
    'Content-Type': 'application/json',
  };

  try {
    const result = await axios.get(url, { headers });
    const paymentStatus = result.data.payment.status;

    if (paymentStatus === "completed") {
      const email = result.data.payment.paymentDetails.email;
      await updatePaymentStatus(email, "Paid");
    }

    res.send(result.data);
  } catch (err) {
    console.error(err);
    res.status(500).send("Internal Server Error");
  }
}

async function updatePaymentStatus(email, status) {
  const uri = "mongodb://localhost:27017/";
  const dbName = "db";
  const client = new MongoClient(uri);

  try {
    await client.connect();
    const db = client.db(dbName);
    const collection = db.collection("registers");

    await collection.updateOne({ email: email }, { $set: { status: status } });

    console.log(`Payment status updated for ${email}.`);
  } catch (err) {
    console.error(err);
  } finally {
    await client.close();
  }
}

module.exports = { Verify };
