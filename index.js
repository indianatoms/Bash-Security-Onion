
 const express = require('express');
const path = require('path');
const app = express();
const fs = require('fs');
const nano = require('nanoseconds');
const publicIp = require('public-ip');
const PublicIp = require('nodejs-publicip');
var ntpClient = require('ntp-client');
const dns = require('dns');
var async = require('async');
const exec = require('child_process').exec


//Set static folder
//app.use(express.static(path.join(__dirname, 'public')))

//homepage
app.get('/', function (req, res) {
        res.send('ETSI MP1 - TRY - /timing/current_time || /timing/timing_caps')
        }
)



//display /timing/current_time page
app.get('/timing/current_time', function (req, res)
{
        var seconds = new Date().getTime() / 1000;
        seconds = Math.floor(seconds);
        //nano seconds do not work properly
        var timeInNs = nano(process.hrtime());
        var istracable = "TRACEABLE";
                res.json({
                        seconds : `${seconds}`,
                        nanosecond : `${timeInNs}`,
                        timeSourceStatus : `${istracable}`
                        });
})


function execute(command, callback){
    exec(command, function(error, stdout, stderr){ callback(stdout); });
};


//display /timing/current_time page
app.get('/timing/timing_caps', function (req, res, data) {

//function nearestPow2( aSize ){
//  return Math.round( Math.log2( aSize ));
//}
//var timeAsPow = nearestPow2(timeSpent);


var seconds = new Date().getTime() / 1000;
 seconds = Math.floor(seconds);
//nano seconds do not work properly
var timeInNs = nano(process.hrtime());
//IP or DNS name? When?
var ip = require("ip");

var serverAddrType = "IP_ADDRESS";


var myCallback = function(data,data2) {
  var str = data;
  var str2 = data2;
  str = str.substring(6);
  var arr = str.split("\n").map(val => Number(val));
  var arr2 = str2.split(" ").map(val => Number(val));
  var max = Math.max(...arr);
  var min = Math.min(...arr);
  arr.splice(arr.indexOf(min), 1);
  min = Math.min(...arr);
  var minPoll = Math.log2(min);
  var maxPoll = Math.log2(max);
  var auth;
  var keyNumber;
  if(!data2)
        {
        auth="none";
        KeyNumber = null;
        }
  else
        {
        auth="SYMMETRIC_KEY";
        keyNumber = arr2[0]
        }

 //Placing JSON structure on the html site

res.json({
	
timeStamp : {
        seconds : `${seconds}`,
        nanosecond : `${timeInNs}`,
},
ntpServers : [
        {
        ntpServerAddrType : `${serverAddrType}`,
        ntpServerAddr : `${ip.address()}`,
        minPollingInterval : `${minPoll}`,
        maxPollingInterval : `${maxPoll}`,
        localPriority   : "1",
        authenticationOption : `${auth}`,
        authenticationKeyNum : `${keyNumber}`
        }
],
        ptpMasters :
                [
                        {
                        ptpMasterIpAddress : `${ip.address()}`,
                        ptpMasterLocalPriority : '1',
                        delayReqMaxRate : '10'
                        }
                ]

        });

  };

var usingItNow = function(callback){

execute("ntpq -p | awk '{print $6}'", function(name){
        execute("cat /etc/ntp.keys", function(email){
            callback(name, email);
        });
    });
};



usingItNow(myCallback);

});


const PORT = process.env.PORT || 5050;

app.listen(PORT, () => console.log(`Server started on port ${PORT}`));

	
