while($true){
     test-connection google.com -count 1 
     sleep -MilliSeconds 1000 |
     select @{N='Time';E={[dateTime]::Now}},
          @{N='Destination';E={$_.address}},
          replysize,
          @{N='Time(ms)'; E={$_.ResponseTime}}
}g