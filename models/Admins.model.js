const mongoose = require('mongoose');


const AdminSchema = mongoose.Schema({
    username: {
        type: String,
    },
    password: {
        type: String,
    },
    role: {
        type: String,
    },
    loginDeviceIp: {
        type: String,
    },
});

const Admins = mongoose.model("Admins", AdminSchema);

module.exports = Admins;
