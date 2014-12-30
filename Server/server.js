var express = require('express');
var http = require('http');
var WebSocket = require('ws');

var allowCrossDomain = function(req, res, next) {
    res.header('Access-Control-Allow-Origin', '*');
    res.header('Access-Control-Allow-Methods', 'GET,PUT,POST,DELETE');
    res.header('Access-Control-Allow-Headers', 'Content-Type');
    next();
};

var app = express();
app.use(allowCrossDomain);
app.use(express.bodyParser());
app.use(express.cookieParser());
app.use(express.session({secret: '2234567890QWERTY'}));
app.use(app.router);

var todos = [];

todos.push({ id: 1, title: "Todo 1", subject: "BlaBla", doneDate: "" });
todos.push({ id: 2, title: "Todo 2", subject: "BlaBlaBlaBla", doneDate: "" });

app.get('/', function (req, res) {
	console.log('get /');
	console.log(todos);
	res.json(todos);		 
});

app.post('/', function (req, res) {
	console.log('post /');
	var id = req.body.id;
	if (id == 0) {
		console.log('new todo')
		id = todos.length + 1;
	}
 	var todo = { id: id, title: req.body.title, subject: req.body.subject, doneDate: req.body.doneDate };
	console.log(todo);
	todos[id - 1] = todo;
	res.json(todo);
});

app.listen(9000);