const express = require('./node_modules/express')
const mysql = require('./node_modules/mysql')
const path = require('./node_modules/path')
const app = express()

const port = 5000

var db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password",
  port: 8889
})

db.connect(function(err) {
  if (err){
  	console.log('Error during connection: ', err.message)
  	return
  }
  else{
  	console.log('Connected!')
  }
})

global.db = db

app.listen(port, () => {
	console.log('Server running on port: ', port)
})

app.use( '/' , express.static(path.join(__dirname ,'..' ,'FrontEnd')));

/*
app.get('/', function(req, res){
	res.sendFile(path.join(__dirname, '../FrontEnd/', 'index.html'))
})
*/
