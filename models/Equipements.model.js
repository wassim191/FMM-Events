const mongoose = require("mongoose");

const Equipementschema = mongoose.Schema({
    Equipementname: {
        type: String,
    },
    quantity: {
        type: Number,
    },
});

const Equipements = mongoose.model("Equipements", Equipementschema);

module.exports = Equipements;