const Jimp = require("jimp");
const mongoose = require('mongoose');
const { MongoClient } = require('mongodb');

const uri = 'mongodb://localhost:27017/db';


const client = new MongoClient(uri, { useNewUrlParser: true,
useUnifiedTopology: true,  })
 
async function getFirstChampionName() {
    try {
        await client.connect();

        const database = client.db('db');
        const collection = database.collection('formaters');

        const cursor = collection.find();

        const documents = await cursor.toArray();

        if (documents.length > 0) {
            console.log(documents[0].email);

        } else {
            console.log('No documents found.');
        }
    } finally {
        await client.close();
    }
}



getFirstChampionName();


(
  async function () {
    const image = await Jimp.read("Attestationn.png");

    const font = await Jimp.loadFont(Jimp.FONT_SANS_32_BLACK);
    const font2 = await Jimp.loadFont(Jimp.FONT_SANS_16_BLACK);

    image.print(font, 596, 350, 'wassim mansour');



    const customFontSiz = 33;

    const textImag = await new Jimp(400, 50, 0x0);
    textImag.print(font, 0, 0, {
      text: 'Anatomy ',
      alignmentX: Jimp.HORIZONTAL_ALIGN_LEFT,
      alignmentY: Jimp.VERTICAL_ALIGN_TOP,
    });

    textImag.scaleToFit(400, customFontSiz);

    image.composite(textImag.color([{ apply: 'blue', params: [70] }]), 779, 418, {
      mode: Jimp.BLEND_SOURCE_OVER,
      opacitySource: 1,
      opacityDest: 1,
    });



    const customFontSize = 30;

    const textImagee = await new Jimp(200, 50, 0x0);
    textImagee.print(font, 0, 0, {
      text: '15/02/2024',
      alignmentX: Jimp.HORIZONTAL_ALIGN_LEFT,
      alignmentY: Jimp.VERTICAL_ALIGN_TOP,
    });

    textImagee.scaleToFit(200, customFontSize);

    image.composite(textImagee.color([{ apply: 'blue', params: [70] }]), 206, 183, {
      mode: Jimp.BLEND_SOURCE_OVER,
      opacitySource: 1,
      opacityDest: 1,
    });


    const customFontSizee = 33;

    const textImageee = await new Jimp(400, 50, 0x0);
    textImageee.print(font, 0, 0, {
      text: '17 janvier 2024 ',
      alignmentX: Jimp.HORIZONTAL_ALIGN_LEFT,
      alignmentY: Jimp.VERTICAL_ALIGN_TOP,
    });

    textImageee.scaleToFit(400, customFontSizee);

    image.composite(textImageee.color([{ apply: 'blue', params: [70] }]), 335, 461, {
      mode: Jimp.BLEND_SOURCE_OVER,
      opacitySource: 1,
      opacityDest: 1,
    });

    image.write("attt.png");
  }
)();
