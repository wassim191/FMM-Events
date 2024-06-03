const mongoose = require("mongoose");

const coursesSchema = mongoose.Schema({
    Prof: {
        type: String,
        required: true,
        trim: true,
    },
    description: {
        type: String,
        required: true,
        trim: true,
    },
    quantity: {
        type: Number,
    },
    images: [{
        type: String,
    }],
    price: {
        type: Number,
        required: true,
    },
    category: {
        type: String,
        required: true,
    },
    Salle: {
        default: "",
        type: String,
    },
    status: {
        default: "pending",
        type: String,
    },
    Tel: {
        default: "0",
        type: Number,
    },
    Timeofstart: {
        type: Date, 
    },
    Timeofend: {
        type: Date, 
    },
    Date: {
        default: Date.now(),
        type: Date,
    },
    email: String,
    qrCode: {
        type: String,
    },
    Equipement: [{
        name: String,
        quantity: Number,
    }]
});

const Courses = mongoose.model("Courses", coursesSchema);

module.exports = Courses;
