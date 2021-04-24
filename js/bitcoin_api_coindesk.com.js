var http = require('http');

http.get({
        host: 'api.coindesk.com',
        path: '/v1/bpi/currentprice.json'
        },
        function(response) {
                // Continuously update stream with data
                var body = '';
                response.on('data', function(d) { body += d; });
                response.on('end', function() {

                        // Data reception is done, do whatever with it!
                        var parsed = JSON.parse(body);
                        console.log(parsed.bpi.USD.rate);
                });
        }
);
