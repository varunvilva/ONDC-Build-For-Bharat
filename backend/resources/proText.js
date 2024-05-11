var express = require('express');
require('dotenv').config();
var get_text = require('../middleware/proTextMiddleware');
var cors = require('cors');

var corsOptions = require('../middleware/cors');
const { GoogleGenerativeAI } = require("@google/generative-ai");
var router = express.Router();
const genAI = new GoogleGenerativeAI(process.env.GOOGLE_API_KEY);



router.post("/", cors(corsOptions),async (req, res) => {
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