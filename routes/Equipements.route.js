const express=require("express");
const Equipements = require("../models/Equipements.model");
const router = express.Router();

router.post('/addEquipement', async (req, res) => {
    try {
      const { Equipementname, quantity } = req.body;
      const newEquipement = new Equipements({
        Equipementname,
        quantity,
      });
  
      const savedEquipement = await newEquipement.save(); 
      res.status(201).json(savedEquipement); 
      console.log(savedEquipement); 
    } catch (err) {
      console.error(err);
      res.status(500).json({ error: "Internal server problem" });
    }
  });
  

router.get('/getequipement',async (req,res)=>{
try{
const Equipementss = await Equipements.find();
if(Equipementss){
    res.json(Equipementss);
}else{
    res.json({message:"Equipements not found"})
}
}catch(error){
    console.error(error)
    res.status(500).json({message:"Internal Server error"})
}
});



router.post('/getequipementbyname', async (req, res) => {
    try {
      const { Equipementname } = req.body;
      const equipement = await Equipements.findOne({ Equipementname }); 
      if (equipement) {
        res.json(equipement);
      } else {
        res.status(404).json({ message: "Equipement not found" }); 
      }
    } catch (error) {
      console.error(error);
      res.status(500).json({ message: "Internal Server error" });
    }
  });
  
router.put('/updatequipement',async (req,res)=>{
try{
    const { Equipementname, quantity, _id } = req.body;
    const updatedEquip = await Equipements.findOneAndUpdate(
        { _id },
        { Equipementname, quantity },
        { new: true }
      );
      if (updatedEquip) {
        return res.status(200).json({ message: "Equipment updated successfully", updatedEquip });
      } else {
        return res.status(404).json({ message: "Equipment not found" });
      }
}catch(e){
    console.error(e)
    res.status(500).json({message:"Internal Server error"})
}
});


router.delete('/deleteEquipement', async(req,res)=>{
    try{
    const {_id}=req.body;
    const deleteEquipement=await Equipements.findOneAndDelete(
      {_id},
    );
    if (deleteEquipement){
      return res.status(200).json({ message: "course deleted successfully"});
    }else{
      return res.status(404).json({ message: "course not found" });
    }
    }catch(e){
      console.error(e);
      return res.status(500).json({ error: 'Internal Server Error' });
    }
    });




module.exports = router;