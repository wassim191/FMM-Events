const mongoose = require("mongoose");

const wishlistschema = mongoose.Schema({
    Prof: {
        type: String,
        required: true,
        trim: true,
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
});

const Wishlist = mongoose.model("Wishlist", wishlistschema);

module.exports = Wishlist;
