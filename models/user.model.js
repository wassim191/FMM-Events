const mongoose = require('mongoose')
const Schema = mongoose.Schema;
const bcrypt = require('bcrypt')

const newSchema = new Schema(
    {
        _id:{
            type: mongoose.Schema.Types.ObjectId,
        },
        name:String,
        cin:String,
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

newSchema.pre('save',async function(next){
    try{
        const salt =await bcrypt.genSalt(10)
        const hashedpass=await bcrypt.hash(this.password,salt)
        this.password=hashedpass
        next();
    }catch(error) {
        next(error)
    }
})


module.exports = mongoose.model('User',newSchema)