const express = require('express');
const router = express.Router();
const axios = require("axios");
const { MongoClient } = require("mongodb");

router.post("/paymentt", async (req, res) => {
    const url = "https://api.preprod.konnect.network/api/v2/payments/init-payment";
    const { amount, email, id } = req.body; 
    const successUrl = `http://localhost:3002/successurll?email=${encodeURIComponent(email)}&id=${id}`; 
    const payload = {
        "receiverWalletId": "65e8777ce9f3b1ee8017780e",
        "token": "TND",
        "amount": amount,
        "type": "immediate",
        "description": "payment description",
        "acceptedPaymentMethods": ["wallet", "bank_card", "e-DINAR"],
        "lifespan": 10,
        "checkoutForm": true,
        "addPaymentFeesToAmount": true,
        "firstName": "John",
        "lastName": "Doe",
        "phoneNumber": "22777777",
        "email": email,
        "orderId": "1234657",
        "webhook": "https://merchant.tech/api/notification_payment",
        "silentWebhook": true,
        "successUrl": successUrl,
        "failUrl": "https://dev.konnect.network/gateway/payment-failure",
        "theme": "light"
    };

    const headers = {
        'Content-Type': 'application/json',
        'x-api-key': '65e8777ce9f3b1ee8017780a:N4KhyMIpI8gBYUTLN7LNOf8cb'
    };

    try {
        const result = await axios.post(url, payload, { headers });
        res.send(result.data);
    } catch (err) {
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

router.get("/paymentt/:id", async (req, res) => {
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
            await updatePaymentStatus(email, id_payment, "Paid"); 
        }

        res.send(result.data);
    } catch (err) {
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

router.get('/successurll', async (req, res) => {
    try {
        const { email, id } = req.query; 
        if (!email || !id) {
            throw new Error("Email and ID parameters are required");
        }
        await updatePaymentStatus(email, id, "Paid"); 
        res.send("Payment status updated to 'paid'");
    } catch (err) {
        console.error(err);
        res.status(500).send("Internal Server Error");
    }
});

async function updatePaymentStatus(email, id, status) { 
    const uri = "mongodb://localhost:27017/";
    const dbName = "db";
    const client = new MongoClient(uri);

    try {
        await client.connect();
        const db = client.db(dbName);
        const collection = db.collection("registers");

        await collection.updateOne({ email: email, idcourse: id }, { $set: { status: status } }); 

        console.log(`Payment status updated for ${email} with orderId ${id}.`);
    } catch (err) {
        console.error(err);
    } finally {
        await client.close();
    }
}

module.exports = router;
