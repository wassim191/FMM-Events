const nodemailer = require("nodemailer");

const transport = nodemailer.createTransport({
    service:"gmail",
    host:"smtp.gmail.com",
    port:587,
    secure:false,
    auth:{
        user:"barca0483@gmail.com",
        pass:"voyn csdk cgns izbz",
    }
});

module.exports.sendConfirmationEmail = (email,activationCode)=>{
    transport.sendMail({
        from:"barca0483@gmail.com",
        to:email,
        subject:"confirmer votre compte",
        html: `<h1>Email Validation</h1><p>Click <a href="http://localhost:3002/confirm?code=${activationCode}">here</a> to confirm your email.</p>`,
    }).catch((err)=> console.log(err));
};