var express = require("express");
var router = express.Router();
var corsMiddleware = require("../middleware/cors");

/* GET home page. */
router.options("/", corsMiddleware);
router.get("/", function (req, res, next) {
  try {
    res.json({ msg: "Hello World Shelfie" });
  } catch (err) {
    console.log(err);
  }
});

module.exports = router;
