'use strict';

const qr = require('qr-image');
const mongoose = require('mongoose');
const Grid = require('gridfs-stream');

const registerSchema = mongoose.Schema({
    name:String,
    email:String,
    status: {
        default:"Unpayed",
        type: String,
    },
    Profname: {
        type: String,
        trim: true,
    },
    category: {
        type: String,
    },
    idcourse:{
        unique:true,
        type:String,
    },
    qrCode: {
        default:"",
        type: String,
    },
    Attendance: {
        default:false,
        type: Boolean,
    },
});

const Register = mongoose.model("Register", registerSchema);

module.exports = Register;
