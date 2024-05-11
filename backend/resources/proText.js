var express = require('express');
require('dotenv').config();
var get_text = require('../middleware/proTextMiddleware');

const { GoogleGenerativeAI } = require("@google/generative-ai");
var router = express.Router();
const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY);



router.post("/", async (req, res) => {
    try {
        query = req.body.text;
        const result = await get_text(query);
        res.json(result);
    } catch (error) {
        console.log(error);
        res.status(500).send(`Internal Server Error: ${error}`);
    }
});


module.exports = router;