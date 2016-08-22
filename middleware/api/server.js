var express = require('express');
var bodyParser = require('body-parser');
var cassandra = require('cassandra-driver');

var client = new cassandra.Client( { contactPoints : [ 'dse-01.meetlytix.com' ] }, { protocolOptions : { port: 9042 } } );
client.connect(function(err, result) {
    //assert.ifError(err);
    console.log('Connected.');
});

var app = express();
var getRSVPCount = "SELECT time, count FROM meetlytix.rsvp_count where time >= ? ALLOW FILTERING;";

app.use(bodyParser.json());
app.set('json spaces', 2);

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Headers", "Origin, X-Requested-With, Content-Type, Accept");
  next();
});

app.get('/metadata', function(req, res) {
    //console.log(res);
    res.send(client.hosts.slice(0).map(function (node) {
        return { address : node.address, rack : node.rack, datacenter : node.datacenter }
    }));
});


app.get('/getRSVPCount/:date', function(req, res) {
    //console.log(req.params.date);
    //console.log("Parsing Date...");
    var rangeDate = new Date(req.params.date);
    //console.log(rangeDate);
    client.execute(getRSVPCount, [rangeDate], function(err, result) {
        if (err) {
            res.status(404).send({ Error : 'Could not fetch RSVP counts' });
            //console.log(err);
        } else {
            res.json(result);        }
    });
});

var server = app.listen(3000, function() {
    console.log('Listening on port %d', server.address().port);
});
