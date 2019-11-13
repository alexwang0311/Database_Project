var mysql = require('./node_modules/mysql')

var con = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password"
})

con.connect(function(err) {
  if (err){
  	console.log('Error during connection')
  	return
  }
  else{
  	console.log('Connected!')
  }
})
