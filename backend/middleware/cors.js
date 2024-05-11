var cors = require('cors');

var whitelist = ['https://shelfie-8bdc6.web.app/', 'https://shelfie-8bdc6.firebaseapp.com/']
var corsOptions = {
  origin: function (origin, callback) {
    if (whitelist.indexOf(origin) !== -1) {
      callback(null, true)
    } else {
      callback(new Error('Not allowed by CORS'));
    
    }
  }
}

module.exports = cors(corsOptions);