const mongoose = require('mongoose')
const Schema = mongoose.Schema;
const bcrypt = require('bcrypt')

const neSchema = new Schema(
    {
        name:String,
        Expertise:String,
        Poste:String,
        email:String,
        password:String,
        isActive: {
            type:Boolean,
            default:false,
        },
        activationCode:String,
        tokens: [String],

    }
);


neSchema.pre('save',async function(next){
    try{
        const salt =await bcrypt.genSalt(10)
        const hashedpass=await bcrypt.hash(this.password,salt)
        this.password=hashedpass
        next();
    }catch(error) {
        next(error)
    }
})
module.exports = mongoose.model('Formater',neSchema)