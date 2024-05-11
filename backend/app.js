var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');
var cors = require('cors');

var indexRouter = require('./routes/index');
var proTextRouter = require('./resources/proText');
var proVisionRouter = require('./resources/proVision');

var app = express();
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(cors());

app.use('/', indexRouter);
app.use('/pro-text', proTextRouter);
app.use('/pro-vision', proVisionRouter);

// catch 404 and forward to error handler
app.use(require('./errorHandler').errorForwarder);

// error handler
app.use(require('./errorHandler').errorHandler);

module.exports = app;
