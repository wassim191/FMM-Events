
const express=require("express");
const router = express.Router();
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const Admins = require("../models/Admins.model");
const cookieParser = require('cookie-parser');

router.use(cookieParser());
// Function to generate JWT
const generateToken = (admin) => {
    return jwt.sign(
      { username: admin.username, role: admin.role },
      'user',
      { expiresIn: '7d' }
    );
  };

router.post('/signupadmin', async (req, res) => {
    try {
        const existingAdmin = await Admins.findOne({ username: req.body.username });
        if (existingAdmin) {
          return res.json({ message: 'username is not available' });
        }
      const newAdmin = new Admins({
        username: req.body.username,
        password: req.body.password,
        role:req.body.role,
      });
  
      const savedAdmin = await newAdmin.save();
      console.log(savedAdmin);
      res.json(savedAdmin);

    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });
  router.post('/signinAdmin4', async (req, res) => {
    try {
        const { username, password } = req.body;
        const admin = await Admins.findOne({ username,password});

        if (admin ) {
            res.status(200).json({ message: 'Success', authenticated: true });
        } else {
            res.status(401).json({ message: 'Invalid credentials', authenticated: false });
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.post('/signoutAdmin', async (req, res) => {
    try {
        // Clear the token cookie
        res.clearCookie('user');
        res.status(200).json({ message: 'Sign out successful' });
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

  router.post('/signinAdmin3', async (req, res) => {
    try {
        const { username, password } = req.body;
        const admin = await Admins.findOne({ username, password });

        if (admin) {
            const loginDeviceIp = req.ip; // Get the IP address from the request
            await Admins.findByIdAndUpdate(admin._id, { loginDeviceIp });

            // Set a cookie with the JWT
            const token = generateToken(admin); // Assuming you have a function to generate a JWT
            res.cookie('token', token, { httpOnly: true, maxAge: 7 * 24 * 60 * 60 * 1000 }); // Expires in 7 days
            res.status(200).json({ message: 'success', authenticated: true });
        } else {
            res.status(401).json({ message: 'Invalid credentials', authenticated: false });
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});



  router.post('/signinAdmin2', async (req, res) => {
    try {
        const { username, password } = req.body;
        const admin = await Admins.findOne({ username, password });

        if (admin) {
            const loginDeviceIp = req.ip; // Get the IP address from the request
            await Admins.findByIdAndUpdate(admin._id, { loginDeviceIp });

            res.status(200).json({ message: 'success', authenticated: true });
        } else {
            res.status(401).json({ message: 'Invalid credentials', authenticated: false });
        }
    } catch (err) {
        console.error(err);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});
  router.post('/signinAdmin', async (req, res) => {
    try {
      const { username, password } = req.body;
  
      const Admin = await Admins.findOne({ username,password });
     
       if (Admin) {
        res.status(200).json({ message: 'success',authenticated: true });
      }else {
      res.status(401).json({ message: 'Invalid credentials',authenticated: false,
    });}
  
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });

  router.get("/getAdmins",async(req,res) =>{
    try{
      
        const Admin = await Admins.find(); 
        res.json(Admin); 
  
    }catch(e){
        console.error('Error adding Admin:', e);
        res.status(500).json({ error: 'Internal Server Error' });
    }
  
  });
  

  router.put('/updateAdmin', async (req, res) => {
    try {
        const {username, password, role,_id} = req.body;
        const updateAdmin = await Admins.findOneAndUpdate(
          {_id},
          {
            username, 
            password,
            role,
            
          },
      );
        if (updateAdmin) {
            return res.status(200).json({ message: "Admin updated successfully"});
        } else {
            return res.status(404).json({ message: "Admin not found" });
        }
    } catch (e) {
        console.error(e);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});


router.delete('/deleteAdmin', async(req,res)=>{
try{
const {_id}=req.body;
const deleteAdmin=await Admins.findOneAndDelete(
  {_id},
);
if (deleteAdmin) {
  return res.status(200).json({ message: "Admin deleted successfully"});
}else{
  return res.status(404).json({ message: "Admin not found" });
}
}catch(e){
  console.error(e);
  return res.status(500).json({ error: 'Internal Server Error' });
}
});


  router.post('/countAdmin',async (req,res)=>{
    try{
      const countAdmins = await Admins.countDocuments();
      res.json({number_of_Admins:countAdmins});
    }catch(e){
      console.error(e);
      return res.status(500).json({ error: 'Internal Server Error' }); 
    }
  });

module.exports=router;
