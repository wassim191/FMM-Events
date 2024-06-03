const express = require('express');
const router = express.Router();
const mongoose = require("mongoose");
const Courses = require("../models/Courses");
const Register = require('../models/Register.model');
const path = require('path');
const qrCode = require('qrcode');
const Wishlist = require('../models/wishlist');
const cors = require('cors'); 
router.use(cors());
const axios = require('axios');
const Formater=require('../models/formater.model');
const User = require('../models/user.model');
router.use(express.json());

router.use(express.static(path.join(__dirname, 'public')));

router.post("/addcourse", async (req, res) => {
  try {
      const { Prof, description, quantity, price, images, category, Tel, email, qrCode, Timeofstart, Timeofend, Date, equipment } = req.body;
      
      const newCourse = new Courses({
          Prof,
          description,
          quantity,
          price,
          category,
          images,
          Tel,
          email,
          qrCode,
          Timeofstart,
          Timeofend,
          Date,
          Equipement: equipment,
      });
      
      const savedCourse = await newCourse.save();
      res.json(savedCourse);
  } catch (e) {
      console.error('Error adding course:', e);
      res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.get("/getcourse",async(req,res) =>{
    try{
        const allCourses = await Courses.find(); 
        res.json(allCourses); 

    }catch(e){
        console.error('Error adding course:', e);
        res.status(500).json({ error: 'Internal Server Error' });
    }

});


router.get("/getregister",async(req,res) =>{
  try{
    
      const allRegister = await Register.find(); 
      res.json(allRegister); 

  }catch(e){
      console.error('Error adding course:', e);
      res.status(500).json({ error: 'Internal Server Error' });
  }

});


router.post("/getregisterbyidcourseandemail", async (req, res) => {
  try {
    const { idcourse, email } = req.body;

    const register = await Register.findOne({ idcourse, email });

    if (register) {
      res.json(register);
    } else {
      res.status(404).json({ error: 'Register not found' });
    }
  } catch (e) {
    console.error('Error fetching register:', e);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



router.get('/courses', async (req, res) => {
  try {
    const { Date: dateString } = req.query;
    const selectedDate = new Date(dateString);
    const nextDate = new Date(selectedDate);
    nextDate.setDate(selectedDate.getDate() + 1);
    const filteredCourses = await Courses.find({
      Date: {
        $gte: selectedDate, 
        $lt: nextDate, 
      }
    });
    res.json(filteredCourses);
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
});

router.put('/updatecourse', async (req, res) => {
  const { _id, Prof, description, quantity, price, images, category, Salle, status, Tel, Time, Date, email } = req.body;
  try {
    const course = await Courses.findOneAndUpdate(
      { _id },
      {
        Prof,
        description,
        quantity,
        price,
        images,
        category,
        Salle,
        status,
        Tel,
        Time,
        Date,
        email,
      },
    );
    if (course) {
   
      if (status === 'active') {
        const qrCodeData = `${_id}`;
        const qrCodeImage = await qrCode.toDataURL(qrCodeData);
        await Courses.findOneAndUpdate(
          { _id },
          { $set: { qrCode: qrCodeImage } },
          { new: true, upsert: true }
        );
        
        const courseemail = await Courses.findOne({ _id });
      const courseEmail = courseemail.email;

        const formater = await Formater.findOne({ email: courseEmail });
        const userr=await User.find();
        if (formater) {
          const tokens = formater.tokens;

          const notificationData = {
            notification: {
              title: 'Course Approved',
              body: `The course has been approved.`
            }
          };

          const fcmRequests = tokens.map(token => {
            const config = {
              method: 'post',
              maxBodyLength: Infinity,
              url: 'https://fcm.googleapis.com/fcm/send',
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'key=AAAAHWfEdtc:APA91bGMvGz0J8kD57OFK1SCTjPNVEhuyXFFAGRsr9h6DGaxT42iR-C9Ulr4c7sBh2B3j0smK85a2L26zqeMOR6mB0RUTscxnyNvowlrVvRKtjgHLCe4JkAzbPBTh0bxldifNY47l1pY'
              },
              data: JSON.stringify({ ...notificationData, to: token })
            };
            return axios.request(config);
          });

          await Promise.all(fcmRequests);


        }
       

        res.json({ message: 'Course updated successfully', qrCode: qrCodeImage });
      } else {
        const courseemail = await Courses.findOne({ _id });
        const courseEmail = courseemail.email;

        const formater = await Formater.findOne({ email: courseEmail });
        
        if (formater) {
          const tokens = formater.tokens;

          const notificationData = {
            notification: {
              title: 'Course updated',
              body: `The course has been updated.`
            }
          };

          const fcmRequests = tokens.map(token => {
            const config = {
              method: 'post',
              maxBodyLength: Infinity,
              url: 'https://fcm.googleapis.com/fcm/send',
              headers: {
                'Content-Type': 'application/json',
                'Authorization': 'key=AAAAHWfEdtc:APA91bGMvGz0J8kD57OFK1SCTjPNVEhuyXFFAGRsr9h6DGaxT42iR-C9Ulr4c7sBh2B3j0smK85a2L26zqeMOR6mB0RUTscxnyNvowlrVvRKtjgHLCe4JkAzbPBTh0bxldifNY47l1pY'
              },
              data: JSON.stringify({ ...notificationData, to: token })
            };
            return axios.request(config);
          });

          await Promise.all(fcmRequests);
        }
        res.json({ message: 'Course updated successfully' });
      }
    } else {
      return res.status(404).json({ error: 'Course not found' });
    }
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


router.put('/updateecourse', async (req, res) => {
  const { _id, Salle, status } = req.body;
  try {
    const course = await Courses.findOneAndUpdate(
      { _id },
      { Salle, status },
      { new: true } 
    );
    if (course) {
      res.status(200).json(course);
    } else {
      res.status(404).json({ error: 'Course not found' });
    }
  } catch (err) {
    console.error('Error updating course:', err);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});


router.delete('/deletecourse', async(req,res)=>{
  try{
  const {_id}=req.body;
  const deletecourse=await Courses.findOneAndDelete(
    {_id},
  );
  if (deletecourse){
    return res.status(200).json({ message: "course deleted successfully"});
  }else{
    return res.status(404).json({ message: "course not found" });
  }
  }catch(e){
    console.error(e);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
  });

router.post('/countcourses',async(req,res)=>{
try{
const countcourses = await Courses.countDocuments();
res.json({number_of_courses:countcourses})
}catch(e){
    console.error(err);
    res.status(500).json({ error: 'Internal Server Error' });
}

});

router.post("/register", async (req, res) => {
    try {
        const {name, email, Profname,category,idcourse,qrCode } = req.body;
        const register = new Register({
            name,
            email,
            Profname,
            category,
            idcourse,
            qrCode,
        });
        const savedRegister = await register.save();
        res.json(savedRegister);
    } catch (e) {
        console.error('Error adding course:', e);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.put("/updatregister", async (req, res) => {
  try {
    const { _id, name, email, Profname, category, idcourse, qrCode, Attendance,status } = req.body;
    const updatedRegister = await Register.findOneAndUpdate(
      { _id: _id },
      { name, email, Profname, category, idcourse, qrCode, Attendance,status },
      { new: true }
    );

    if (updatedRegister) {
      res.status(200).json({ message: 'Record updated successfully' });
    } else {
      res.status(404).json({ error: 'Register not found' });
    }
  } catch (error) {
    console.error('Error updating register:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});
router.delete('/deleteregister', async(req,res)=>{
  try{
  const {_id}=req.body;
  const deleteregister=await Register.findOneAndDelete(
    {_id},
  );
  if (deleteregister){
    return res.status(200).json({ message: "register deleted successfully"});
  }else{
    return res.status(404).json({ message: "register not found" });
  }
  }catch(e){
    console.error(e);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
  });


router.get('/pass', async (req, res) => {
    const email = req.query.code;
  
    try {
        const result = await Register.updateOne(
          { email },
          { $set: {status:"Payed"}} 
        );
        console.log(result);
  
        res.sendFile(path.join(__dirname, 'public', 'confirmation.html'));
    } catch (error) {
      console.error(error);
      res.status(500).send('Internal Server Error');
    }
  });
  
  
  router.post('/generatqr/:id_course', async (req, res) => {
    const { id_course } = req.params;
  
    try {
      const course = await Courses.findOne({ _id: id_course });
        if (course.status === 'Unpayed') {
        const qrCodeData = `${id_course}`;
        const qrCodeImage = await qrCode.toDataURL(qrCodeData);
        const updatedCourse = await Courses.findOneAndUpdate(
          { _id: id_course },
          { $set: { qrCode: qrCodeImage } },
          { new: true, upsert: true }
        );
          res.json({ success: true, qrCode: qrCodeImage });
      } else {
        res.status(400).json({ success: false, error: 'Course is not in unpayed status' });
      }
    } catch (error) {
      console.error('Error:', error);
      res.status(500).json({ success: false, error: 'Internal Server Error' });
    }
  });
  


  router.post('/generateQR/:id_course', async (req, res) => {
    const { id_course } = req.params;
  
    try {
      const qrCodeData = `${id_course}`;
      const qrCodeImage = await qrCode.toDataURL(qrCodeData);
  
      const course = await Courses.findOneAndUpdate(
        { _id: id_course },
        { $set: { qrCode: qrCodeImage } },
        { new: true, upsert: true }
      );
      res.json({ success: true, qrCode: qrCodeImage });
    } catch (error) {
      console.error('Error:', error);
      res.status(500).json({ success: false, error: 'Internal Server Error' });
    }
  });

  router.post('/generateqrcodee', async (req, res) => {
    const { id_register } = req.body;
  
    try {
      const qrCodeData = `${id_register}`;
      const qrCodeImage = await qrCode.toDataURL(qrCodeData);
  
      const course = await Register.findOneAndUpdate(
        { _id: id_register },
        { $set: { qrCodeuser: qrCodeImage } },
        { new: true, upsert: true }
      );
      res.json({ success: true, qrCode: qrCodeImage });
    } catch (error) {
      console.error('Error:', error);
      res.status(500).json({ success: false, error: 'Internal Server Error' });
    }
  });

  router.post('/scanQR', async (req, res) => {
    const { qrCode, idcourse } = req.body;
  
    try {
      const user = await Register.findOne({ qrCode, idcourse });
      if (user) {
        const status = user.status;
  
        if (status === 'Paid') {
          res.json({ success: true, message: 'Payment already received' });
        } else {
          res.json({ success: true, message: 'Payment not received yet' });
        }
      } else {
        res.status(404).json({ success: false, error: 'User not found' });
      }
    } catch (error) {
      console.error('Error:', error);
      res.status(500).json({ success: false, error: 'Internal Server Error' });
    }
  });

  router.post('/scanscan', async (req, res) => {
    const { qrCode } = req.body;
  
    try {
      const user = await Register.findOne({ qrCode });
      if (user) {
        const status = user.status;
  
        if (status === 'Paid') {
          res.json({ success: true, message: 'Payment already received' });
        } else {
          res.json({ success: true, message: 'Payment not received yet' });
        }
      } else {
        res.status(404).json({ success: false, error: 'User not found' });
      }
    } catch (error) {
      console.error('Error:', error);
      res.status(500).json({ success: false, error: 'Internal Server Error' });
    }
  });

  router.post('/scanscanscan', async (req, res) => {
    const { _id_course,email } = req.body;
  
    try {
      const user = await Register.findOne({ idcourse:_id_course,email:email});
      if (user) {
        const status = user.status;
        if (status === 'Paid') {
          const enter = await user.updateOne({$set:{Attendance: true}})
          if (enter){
            res.json({ success: true, message: 'You are confirmed' });
          }else{
            res.json({ success: false, message: 'check something' });
          }
        } else {
            res.json({ success: true, message: 'You are not confirmed' });
        }
      } else {
        res.status(404).json({ success: false, error: 'User not found' });
      }
    } catch (error) {
      console.error('Error:', error);
      res.status(500).json({ success: false, error: 'Internal Server Error' });
    }
  });

  router.post('/dashscan', async (req, res) => {
    const { id_register } = req.body;
    try {
      const user = await Register.findOne({ _id:id_register});
      if (user) {
        const status = user.status;
        if (status === 'Unpayed') {
          const enter = await user.updateOne({$set:{status: 'Paid'}})
          if (enter){
            res.json({ success: true, message: 'Status Updated to Paid' });
          }else{
            res.json({ success: false, message: 'check something' });
          }
        } else {
            res.json({ success: true, message: 'Status not Updated to Paid' });
        }
      } else {
        res.status(404).json({ success: false, error: 'Register not found' });
      }
    } catch (error) {
      console.error('Error:', error);
      res.status(500).json({ success: false, error: 'Internal Server Error' });
    }
  });

  router.post('/searchidcourse', async (req, res) => {
    const { _id_course,email } = req.body;
  
    try {
      const user = await Register.findOne({ idcourse:_id_course,email:email});
      if (user) {      
            res.json({ confirmation:true, message: 'You are Registered' });
      } else{
        res.json({ confirmation:false, message: 'You are not Registered' });

      }
    } catch (error) {
      console.error('Error:', error);
      res.status(500).json({ success: false, error: 'Internal Server Error' });
    }
  });
  router.post("/addthecourse", async (req, res) => {
    try {
        const {Prof, description, price, category,Tel,Salle,Date,Time,status } = req.body;
        const newCourse = new Courses({
            Prof,
            description,
            price,
            category,
            Tel,
            Salle,
            Date,
            Time,
            status,
            
        });
        const savedCourse = await newCourse.save();
        res.json(savedCourse);
    } catch (e) {
        console.error('Error adding course:', e);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});
  
router.post("/addwishlist", async (req, res) => {
  try {
    const { Prof, price, images, category, checked, idcourse,email } = req.body;
    
    const existingItem = await Wishlist.findOne({ idcourse,email });
    if (existingItem) {
      return res.status(400).json({ error: 'Course already in wishlist' });
    }
    
    const newwishlist = new Wishlist({
      Prof,
      price,
      category,
      images,
      checked,
      idcourse,
      email,
    });
    const savedwishlist = await newwishlist.save();
    res.json(savedwishlist);
  } catch (e) {
    console.error('Error adding course:', e);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.get("/getwishlistt", async (req, res) => {
  try {
    const { email, Prof, category } = req.query;
    const wishlistItems = await Wishlist.find({ email, Prof, category });

    res.json(wishlistItems);
  } catch (error) {
    console.error('Error fetching wishlist:', error);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.get("/getwishlist",async(req,res) =>{
  try{
      const allwishlist = await Wishlist.find({checked: true  });
      res.json(allwishlist); 

  }catch(e){
      console.error('Error getting wishlist:', e);
      res.status(500).json({ error: 'Internal Server Error' });
  }

});



router.get("/gettttwishlist", async (req, res) => {
  try {
    const { idcourse } = req.query;

    const wishlistItem = await Wishlist.findOne({ idcourse:idcourse });

    if (wishlistItem) {
      res.json({ exists: true });
    } else {
      res.json({ exists: false });
    }
  } catch (e) {
    console.error('Error getting wishlist:', e);
    res.status(500).json({ error: 'Internal Server Error' });
  }
});



router.delete('/deletewishlist', async(req,res)=>{
  try{
  const {_id}=req.body;
  const deletewishlist=await Wishlist.findOneAndDelete(
    {_id},
  );
  if (deletewishlist){
    return res.status(200).json({ message: "wishlist deleted successfully"});
  }else{
    return res.status(404).json({ message: "wishlist not found" });
  }
  }catch(e){
    console.error(e);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
  });

module.exports = router;
