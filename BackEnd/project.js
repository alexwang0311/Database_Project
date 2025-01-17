const express = require('./node_modules/express');
const mysql = require('./node_modules/mysql');
const path = require('./node_modules/path');
const app = express();

const port = 5000;

var db = mysql.createConnection({
  host: "localhost",
  user: "root",
  password: "password",
  database: 'project2',
  multipleStatements: true,
  port: 8889
});

db.connect(function(err) {
  if (err){
  	console.log('Error during connection: ', err.message);
  	return;
  }
  else{
  	console.log('Connected!');
  }
})

global.db = db

app.listen(port, () => {
	console.log('Server running on port: ', port);
})

app.use( '/' , express.static(path.join(__dirname ,'..' ,'FrontEnd')));

// Middleware APIs
// Query middleware
app.get('/query/:date', (req, res) => {
  var date = JSON.parse(req.params.date);
  var year = date.year;
  var month = date.month;
  //console.log(year, month);
  if(month != 0){
    db.query('SELECT * FROM (accident_info INNER JOIN location_info USING (accident_id) INNER JOIN harm_info USING (accident_id) INNER JOIN weather_info USING (accident_id)) WHERE YEAR(accident_date) = ' + year + ' AND MONTH(accident_date) = ' + month + ' LIMIT 5000', function(err, result){
      if(err) throw err;
      res.json(result);
    });
  }else{
    db.query('SELECT * FROM (accident_info INNER JOIN location_info USING (accident_id) INNER JOIN harm_info USING (accident_id) INNER JOIN weather_info USING (accident_id)) WHERE YEAR(accident_date) = ' + year + ' LIMIT 5000', function(err, result){
      if(err) throw err;
      res.json(result);
    });
  }
});

// Stored procedure middleware
app.get('/procedure/:date', (req, res) => {
  var date = JSON.parse(req.params.date);
  var year = date.year;
  var month = date.month;
  var procedure = 'CALL filter_time(?,?, @numHitAndRun, @numInjuries, @numDeath); SELECT @numHitAndRun AS numHitAndRun, @numInjuries AS numInjuries, @numDeath AS numDeath;';
  //console.log(year, month);

  db.query(procedure, [year, month], function(err, result){
    if (err) throw err;
    res.json(result);
  });
});