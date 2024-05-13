let cors = require("cors");
require("dotenv").config();

var whitelist = [process.env.FRONTEND_DOMAIN];
var corsOptions = {
  origin: function (origin, callback) {
    console.log(origin);
    console.log(process.env.FRONTEND_DOMAIN);
    if (whitelist.indexOf(origin) !== -1) {
      callback(null, true);
    } else {
      callback(new Error("Not allowed by CORS"));
    }
  },
};

module.exports = cors(corsOptions);
