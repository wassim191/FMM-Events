const express = require('express');
const router = express.Router();
const mongoose = require("mongoose");
const { Add, Verify } = require('../payement/payement');

router.post("/payment",Add)
router.get("/payment/:id",Verify)


  
module.exports=router;
