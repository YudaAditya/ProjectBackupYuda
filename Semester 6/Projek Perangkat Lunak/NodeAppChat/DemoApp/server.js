var express = require('express');
var bodyParser = require('body-parser');
var app = express(); //set reference variable
var http = require('http').Server(app);
var io = require('socket.io')(http);
var mongoose = require('mongoose');

// set port
app.use(express.static(__dirname));//untuk mengatasi error get /
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({exteded: false}));

var dbUrl = 'mongodb://yuda:yuda123456@ds017584.mlab.com:17584/yuda-monggodb';
var Message = mongoose.model("Message", {
    nama: String,
    pesan: String
});


app.get('/pesan', function (req, res) {
    Message.find({}, function (err, pesan) {
        res.send(pesan);
    });
})

app.post('/pesan',async function (req, res) {
    var message = new Message(req.body);

    var savedMessage = await message.save() //untuk menghandle data besar, supaya antri
     // sekarang anonymous functionya di dalam then
        console.log('Tersimpan');
        var sensor = await Message.findOne({pesan: 'badword'})
    if (sensor) {
        await Message.deleteMany({_id: sensor.id});
    } else {
        io.emit('pesan', req.body);
    }
    res.sendStatus(200);

    //     .catch((err)=>{
    //     res.sendStatus(500);
    //     return console(err);
    // })
})



io.on('connection', function (socket) {
    console.log('a user connected !');
})

mongoose.connect(dbUrl,function (err) {
    console.log('berhasil connect ke mlab', err);
})

var server = http.listen(3000, function () {
    console.log("port server adalah ",server.address().port)
});
// app.listen(3000);