var express = require('express');
var router = express.Router();
var cors = require('cors');
var corsOptions = require('../middleware/cors');


/* GET home page. */
router.get('/',cors(corsOptions),function(req, res, next) {
  try{
    res.json({ msg: "Hello World from ExpressJS!"});
  }catch(err){
    console.log(err);
  }
});

// router.use(require('../errorHandler').errorForwarder);
// router.use(require('../errorHandler').errorHandler);
module.exports = router;
