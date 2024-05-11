var express = require('express');
require('dotenv').config();
var get_image = require('../middleware/proVisionMiddleware');

const { GoogleGenerativeAI } = require("@google/generative-ai");
var router = express.Router();
const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY);


router.post("/", async (req, res) => {
    try {
        const img = req.body.image;
        const result = await get_image(img);
        res.json(result);

    } catch (error) {
        console.log(error);
    }
});
module.exports = router;