const express=require("express");
const User=require('../models/user.model')
const Formater=require('../models/formater.model')
const router = express.Router();
const app = express();
const mongoose = require('mongoose');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const { sendConfirmationEmail } = require("./nodemailer");
const path = require('path');
const { Add, Verify } = require("../payement/payement");
const Register = require("../models/Register.model");

router.use(express.static(path.join(__dirname, 'public')));

router.get('/confirm', async (req, res) => {
  const activationCode = req.query.code;
  
  try {
    const result = await User.updateOne({ activationCode }, { $set: { isActive: true } });
    const resultt = await Formater.updateOne({ activationCode }, { $set: { isActive: true } });

    console.log(result);
    console.log(resultt);

    console.log(activationCode);

      res.sendFile(path.join(__dirname, 'public', 'confirmation.html'));
   
  } catch (error) {
    console.error(error);
    res.status(500).send('Internal Server Error');
  }
});





router.post('/signup', async (req, res) => {
    try {
      const existingUser = await User.findOne({ email: req.body.email });
      if (existingUser) {
        return res.json({ message: 'Email is not available' });
      }
      const characters = 
      "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
      let activationCode="";
      for (let i=0;i<25;i++){
        activationCode += characters[Math.floor(Math.random()* characters.length)];
      }
  
      const newUser = new User({
        _id: new mongoose.Types.ObjectId(), 
        email: req.body.email,
        password: req.body.password,
        name:req.body.name,
        cin:req.body.cin,
        activationCode:activationCode,
      });
  
      const savedUser = await newUser.save();
      console.log(savedUser);
      res.json(savedUser);

      sendConfirmationEmail(req.body.email, activationCode); 
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });
  
router.post('/signup2', async (req, res) => {
    try {
      const existingFormater = await Formater.findOne({ email: req.body.email });
      if (existingFormater) {
        return res.json({ message: 'Email is not available' });
      }
      const characters = 
      "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
      let activationCodee="";
      for (let i=0;i<25;i++){
        activationCodee += characters[Math.floor(Math.random()* characters.length)];
      }
  
      const newFormater = new Formater({
        email: req.body.email,
        password: req.body.password,
        name:req.body.name,
        Expertise:req.body.Expertise,
        Poste:req.body.Poste,
        activationCode:activationCodee,
      });
  
      const savedFormater = await newFormater.save();
      console.log(savedFormater);
      res.json(savedFormater);

      sendConfirmationEmail(req.body.email, activationCodee); 
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });
  


  router.post('/signin', async (req, res) => {
    try {
      const { email, password } = req.body;
  
      const user = await User.findOne({ email });
      const formater = await Formater.findOne({ email });

      if (formater && user && await bcrypt.compare(password, user.password)&& user.isActive &&  await bcrypt.compare(password, formater.password)) {
        return res.json({ authenticated: false,
          conflict: true,
          error: "Email exists in both user and formatting collections. Please choose an account to log in.",
      });
  
      }else if (user && await bcrypt.compare(password, user.password)&& user.isActive) {
        const token = jwt.sign({ userId: user._id, role: 'user' }, 'secret', { expiresIn: '1h' });
        return res.json({ token, user, collection: "users",
        authenticated: true, });
      } else if (user && await bcrypt.compare(password, user.password)&& !user.isActive) {
        return res.json({ message:"you should check your email for activation", authenticated: false,
      });

      }else if (formater && await bcrypt.compare(password, formater.password)&& formater.isActive) {
        const token = jwt.sign({ userId: formater._id, role: 'formater' }, 'secret', { expiresIn: '1h' });
        return res.json({ token, formater,collection: "formaters",
        authenticated: true, });
      }else if (formater && await bcrypt.compare(password, user.password)&& !formater.isActive) {
        return res.json({ message:"you should check your email for activation", authenticated: false,
      })}
  
      res.status(401).json({ message: 'Invalid credentials',authenticated: false,
    });
    
  
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });



  router.put('/reset', async (req, res) => {
    const { email, newpassword } = req.body; 
  
    try {
      const user = await User.findOneAndUpdate({ email }, { password: newpassword });
      if (user) {
        return res.json({ message: 'Password reset successful for User' });
      }
  
      const formater = await Formater.findOneAndUpdate({ email }, { password: newpassword });
      if (formater) {
        return res.json({ message: 'Password reset successful for Formater' });
      }
  
      res.status(404).json({ message: 'User or Formater not found' });
  
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });

  router.get('/api/users', async (req, res) => {
    try {
      const user = await User.find();
      res.json(user);
    } catch (error) {
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });
  
  router.get('/api/formater', async (req, res) => {
    try {
      const formater = await Formater.find();
      res.json(formater);
    } catch (error) {
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });

  router.put('/updateuser', async (req, res) => {
    try {
        const {email, name, cin,isActive,_id} = req.body;
        const updatedUser = await User.findOneAndUpdate(
          {_id},
          {
            email,
            name,
            cin,
            isActive,
            
          },
      );
        if (updatedUser) {
            return res.status(200).json({ message: "User updated successfully"});
        } else {
            return res.status(404).json({ message: "User not found" });
        }
    } catch (e) {
        console.error(e);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.put('/updateformater', async (req, res) => {
  try {
      const {email, name, Expertise,Poste,isActive,_id} = req.body;
      const updatedFormater = await Formater.findOneAndUpdate(
        {_id},
        {
          email,
          name,
          Expertise,
          Poste,
          isActive,
        },
    );
      if (updatedFormater) {
          return res.status(200).json({ message: "Formater updated successfully"});
      } else {
          return res.status(404).json({ message: "Formater not found" });
      }
  } catch (e) {
      console.error(e);
      return res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.put('/updateformaterpassbyemail', async (req, res) => {
  try {
    const { email, name, Expertise, Poste, isActive, _id, password } = req.body;
    const salt = await bcrypt.genSalt(10);
    const hashedPass = await bcrypt.hash(password, salt);
    const updatedFormater = await Formater.findOneAndUpdate(
      { email },
      { password: hashedPass }, 
    );

    if (updatedFormater) {
      return res.status(200).json({ message: "Formater updated successfully" });
    } else {
      return res.status(404).json({ message: "Formater not found" });
    }
  } catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
});


router.put('/updateformaterbyemail', async (req, res) => {
  try {
      const {email, name, Expertise,Poste,isActive,_id} = req.body;
      const updatedFormater = await Formater.findOneAndUpdate(
        {email},
        {
          email,
          name,
          Expertise,
          Poste,
          isActive,
        },
    );
      if (updatedFormater) {
          return res.status(200).json({ message: "Formater updated successfully"});
      } else {
          return res.status(404).json({ message: "Formater not found" });
      }
  } catch (e) {
      console.error(e);
      return res.status(500).json({ error: 'Internal Server Error' });
  }
});


router.delete('/deleteuser', async(req,res)=>{
try{
const {_id}=req.body;
const deleteuser=await User.findOneAndDelete(
  {_id},
);
if (deleteuser){
  return res.status(200).json({ message: "user deleted successfully"});
}else{
  return res.status(404).json({ message: "user not found" });
}
}catch(e){
  console.error(e);
  return res.status(500).json({ error: 'Internal Server Error' });
}
});


router.delete('/deleteformater', async(req,res)=>{
  try{
  const {_id}=req.body;
  const deleteformater=await Formater.findOneAndDelete(
    {_id},
  );
  if (deleteformater){
    return res.status(200).json({ message: "formater deleted successfully"});
  }else{
    return res.status(404).json({ message: "formater not found" });
  }
  }catch(e){
    console.error(e);
    return res.status(500).json({ error: 'Internal Server Error' });
  }
  });


  router.post('/countuser',async (req,res)=>{
    try{
      const countuser = await User.countDocuments();
      res.json({number_of_students:countuser});
    }catch(e){
      console.error(e);
      return res.status(500).json({ error: 'Internal Server Error' }); 
    }
  });

  router.post('/countformater',async (req,res)=>{
    try{
      const countformater=await Formater.countDocuments();
      res.json({number_of_formaters:countformater});
    }catch(e){
      console.error(e);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
  });

  router.post('/addlearner', async (req, res) => {
    try {
      const existingUser = await User.findOne({ email: req.body.email });
      if (existingUser) {
        return res.json({ message: 'Email is not available' });
      }
  
      const newUserr = new User({
        _id: new mongoose.Types.ObjectId(), 
        email: req.body.email,
        password: req.body.password,
        name:req.body.name,
        cin:req.body.cin,
        isActive:req.body.isActive,
      });
  
      const savedUser = await newUserr.save();
      console.log(savedUser);
      res.json(savedUser);

    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });

  
  router.post('/addformater', async (req, res) => {
    try {
      const existingUser = await Formater.findOne({ email: req.body.email });
      if (existingUser) {
        return res.json({ message: 'Email is not available' });
      }
  
      const newUserr = new Formater({
        _id: new mongoose.Types.ObjectId(), 
        email: req.body.email,
        password: req.body.password,
        name:req.body.name,
        Expertise:req.body.Expertise,
        Poste:req.body.Poste,
        isActive:req.body.isActive,
      });
  
      const savedUser = await newUserr.save();
      console.log(savedUser);
      res.json(savedUser);

    } catch (err) {
      console.error(err);
      res.status(500).json({ error: 'Internal Server Error' });
    }
  });



  router.put('/updatetokenuser', async (req, res) => {
    try {
        const { token, email } = req.body;

        const updatedUser = await User.findOneAndUpdate(
            { email },
            { $addToSet: { tokens: token } }, 
            { new: true } 
        );

        if (updatedUser) {
            return res.status(200).json({ message: "Token updated successfully" });
        } else {
            return res.status(404).json({ message: "User not found" });
        }
    } catch (e) {
        console.error(e);
        return res.status(500).json({ error: 'Internal Server Error' });
    }
});

router.put('/deletetokenuser', async (req, res) => {
  try {
      const { token, email } = req.body;

      const updatedUser = await User.findOneAndUpdate(
          { email },
          { $pull: { tokens: token } }, 
          { new: true } 
      );

      if (updatedUser) {
          return res.status(200).json({ message: "Token deleted successfully" });
      } else {
          return res.status(404).json({ message: "User not found" });
      }
  } catch (e) {
      console.error(e);
      return res.status(500).json({ error: 'Internal Server Error' });
  }
});





router.put('/updatetokenformater', async (req, res) => {
  try {
      const { token, email } = req.body;

      const updatedUser = await Formater.findOneAndUpdate(
          { email },
          { $addToSet: { tokens: token } }, 
          { new: true } 
      );

      if (updatedUser) {
          return res.status(200).json({ message: "Token updated successfully" });
      } else {
          return res.status(404).json({ message: "User not found" });
      }
  } catch (e) {
      console.error(e);
      return res.status(500).json({ error: 'Internal Server Error' });
  }
});

router.put('/deletetokenformater', async (req, res) => {
try {
    const { token, email } = req.body;

    const updatedUser = await Formater.findOneAndUpdate(
        { email },
        { $pull: { tokens: token } }, 
        { new: true } 
    );

    if (updatedUser) {
        return res.status(200).json({ message: "Token deleted successfully" });
    } else {
        return res.status(404).json({ message: "User not found" });
    }
} catch (e) {
    console.error(e);
    return res.status(500).json({ error: 'Internal Server Error' });
}
});

router.get('/getname/:email', async (req, res) => {
  try {
    const email = req.params.email;
    const user = await Formater.findOne({ email });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ name: user.name });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});



router.get('/getnameuser/:email', async (req, res) => {
  try {
    const email = req.params.email;
    const user = await User.findOne({ email });

    if (!user) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json({ name: user.name });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server Error' });
  }
});
module.exports=router;
