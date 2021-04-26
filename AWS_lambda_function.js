 var https = require('https');
 var AWS = require('aws-sdk');
exports.handler =  (event, context, callback) => {
      console.log(event);
      var invested_price;
      var bought_price;
      var desired_profit;
      var token;
      let response = {};
      let finalresp = {};
      let finalrespbody = {};
    if (event.httpMethod == 'POST') {
        let body = JSON.parse(event.body);
        invested_price = body.invested_price;
        bought_price = body.bought_price;
        desired_profit = body.desired_profit;
        token = body.token;
    
    // The output from a Lambda proxy integration must be 
    // in the following JSON object. The 'headers' property 
    // is for custom response headers in addition to standard 
    // ones. The 'body' property  must be a JSON string. For 
    // base64-encoded payload, you must also set the 'isBase64Encoded'
    // property to 'true'.
    response = {
        "isBase64Encoded": false,
        "statusCode": 200,
        "headers": {"content-Type": "application/json"},
        "body": JSON.stringify(body)
    };
};
       var params = {
                    host: "quote.coins.ph",
                    path: "/v2/markets/BTC-PHP"
    
                    };
    var req = https.request(params, function(res) {
    let data = '';
    console.log('STATUS: ' + res.statusCode);
    res.setEncoding('utf8');
    res.on('data', function(chunk) {
        data += chunk;
    });
    res.on('end', function() {
        finalresp = display(JSON.parse(data), invested_price, bought_price, desired_profit);
        console.log("************************************************************FINAL RESP: ");
        finalresp.then(function(result) {
           finalrespbody = result;
           console.log(finalrespbody);
});
console.log(finalrespbody);
    });
  });
   req.end();
   

  
  async  function display(result, invested_price, bought_price, desired_profit) {
        console.log(result);
        
  var formatter = new Intl.NumberFormat('en-US', {
  style: 'currency',
  currency: 'PHP',
  // These options are needed to round to whole numbers if that's what you want.
  //minimumFractionDigits: 0, // (this suffices for whole numbers, but will print 2500.10 as $2,500.1)
  //maximumFractionDigits: 0, // (causes 2500.99 to be printed as $2,501)
});
    var currentBTC = invested_price/bought_price;
    var sell_price = Number(result.bid);
    var coins_php_val = Number(result.bid) * currentBTC;
    var profit = (Number(result.bid) * currentBTC) - invested_price;
    
// if (profit > desired_profit){
if (true) {
    console.log("-------------------PUBLISHING TO THE DEVICE----------------");
    
//CHANGE ARN to the right target
const new_sns = new AWS.SNS({apiVersion:'2010-03-31'});
var TargetArn;
var PlatformApplicationArn = 'arn:aws:sns:us-east-1:773314055569:app/GCM/CoinsNotifSNS';
var listedEndpoints;

var listparams = {
  PlatformApplicationArn: PlatformApplicationArn
};

await new_sns.listEndpointsByPlatformApplication(listparams, async function(err, data) {
  if (err) console.log(err, err.stack); // an error occurred
  else     {
    //   console.log(data.Endpoints);
      listedEndpoints = data.Endpoints;
      listedEndpoints.forEach(function (item) {
 if (item.Attributes.Token == token) {
     TargetArn = item.EndpointArn;
 }
});

// console.log("------------Target ARN from list: " + TargetArn);
      
  }
}).promise();

if (!TargetArn) {
  var paramscreate = {
 PlatformApplicationArn: PlatformApplicationArn,
  Token: token
};
await new_sns.createPlatformEndpoint(paramscreate, async function(err, data) {
  if (err) console.log(err, err.stack); // an error occurred
  else    {
    //   console.log("------------from CreatePlatformEndpoint---------------");
    //   console.log(data);
      TargetArn = data.EndpointArn;
  }         // successful response
}).promise();
// console.log("------------Target ARN from create: " + TargetArn);
}

    let payload = {
        default: 'default',
        GCM : {
            notification: {
                body: " Selling Price: " + formatter.format(sell_price) + 
                "\n Total Price of your BTC on Coins: " + formatter.format(coins_php_val) +
                "\n Total Profit: " + formatter.format(profit) ,
                title: result.symbol,  
                sound: "default"
            }
        }
        
    }
    
    payload.GCM = JSON.stringify(payload.GCM);
    payload = JSON.stringify(payload);
    const params_sns = {
        Message: payload,
        TargetArn: TargetArn,
        MessageStructure: 'json'
    }
    console.log("------------------------FINAL MESSAGE---------------------");
    console.log(params_sns);
    


//     await new_sns.publish(params_sns).promise();
};
    console.log(JSON.stringify(response));
    return response;
    }

callback(null, finalresp);

 };